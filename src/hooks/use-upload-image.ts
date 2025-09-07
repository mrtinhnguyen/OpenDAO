import { useState } from 'react';

import { api } from '@/lib/api';

interface UploadOptions {
  folder: string;
  public_id?: string;
  resource_type?: 'image' | 'video' | 'raw' | 'auto';
}

interface CloudinaryUploadResult {
  public_id: string;
  secure_url: string;
  url: string;
  format: string;
  width?: number;
  height?: number;
  bytes: number;
  created_at: string;
}

interface UseUploadReturn {
  uploadFile: (
    file: File,
    options: UploadOptions,
  ) => Promise<CloudinaryUploadResult>;
  uploadAndReplace: (
    file: File,
    options: UploadOptions,
    oldImageUrl?: string,
  ) => Promise<CloudinaryUploadResult>;
  uploading: boolean;
  progress: number;
  error: string | null;
}

export const useUploadImage = (): UseUploadReturn => {
  const [uploading, setUploading] = useState(false);
  const [progress, setProgress] = useState(0);
  const [error, setError] = useState<string | null>(null);

  const uploadFileDirect = async (
    file: File,
    options: UploadOptions,
  ): Promise<CloudinaryUploadResult> => {
    // Fallback: Use the existing /api/image/upload endpoint
    try {
      const base64Image = await fileToBase64(file);
      const base64Content = base64Image.split(',')[1];

      const response = await api.post('/api/image/upload', {
        imageBase64: base64Content,
        type: 'image',
        folder: options.folder,
      });

      // Convert the response to match CloudinaryUploadResult interface
      const result: CloudinaryUploadResult = {
        public_id:
          response.data.url.split('/').pop()?.split('.')[0] || 'unknown',
        secure_url: response.data.url,
        url: response.data.url,
        format: 'webp',
        bytes: file.size,
        created_at: new Date().toISOString(),
      };

      return result;
    } catch (error: any) {
      throw new Error(
        `Fallback upload failed: ${error.response?.data?.error || error.message}`,
      );
    }
  };

  const fileToBase64 = (file: File): Promise<string> => {
    return new Promise((resolve, reject) => {
      const reader = new FileReader();
      reader.readAsDataURL(file);
      reader.onload = () => resolve(reader.result as string);
      reader.onerror = (error) => reject(error);
    });
  };

  const compressImage = async (file: File): Promise<File> => {
    return new Promise((resolve, reject) => {
      const canvas = document.createElement('canvas');
      const ctx = canvas.getContext('2d');
      const img = new Image();

      img.onload = () => {
        try {
          let { width, height } = img;

          const MAX_DIMENSION = 1920;
          if (width > MAX_DIMENSION || height > MAX_DIMENSION) {
            if (width > height) {
              height = (height * MAX_DIMENSION) / width;
              width = MAX_DIMENSION;
            } else {
              width = (width * MAX_DIMENSION) / height;
              height = MAX_DIMENSION;
            }
          }

          canvas.width = width;
          canvas.height = height;

          ctx?.drawImage(img, 0, 0, width, height);

          const outputFormat = 'image/webp';
          const quality = 0.8;

          canvas.toBlob(
            (blob) => {
              if (blob) {
                const extension = outputFormat.split('/')[1];
                const originalName = file.name.replace(/\.[^/.]+$/, '');
                const newFileName = `${originalName}.${extension}`;

                const compressedFile = new File([blob], newFileName, {
                  type: outputFormat,
                  lastModified: Date.now(),
                });
                resolve(compressedFile);
              } else {
                reject(new Error('Failed to compress image'));
              }
            },
            outputFormat,
            quality,
          );
        } catch (error) {
          reject(error);
        }
      };

      img.onerror = () => reject(new Error('Failed to load image'));
      img.src = URL.createObjectURL(file);
    });
  };

  const uploadFile = async (
    file: File,
    options: UploadOptions,
  ): Promise<CloudinaryUploadResult> => {
    if (!file) {
      throw new Error('No file provided');
    }

    setUploading(true);
    setProgress(0);
    setError(null);

    // Check if we have required environment variables
    const cloudinaryApiKey = process.env.NEXT_PUBLIC_CLOUDINARY_API_KEY;
    const cloudinaryCloudName = process.env.NEXT_PUBLIC_CLOUDINARY_CLOUD_NAME;

    console.log('Cloudinary config check:', {
      hasApiKey: !!cloudinaryApiKey,
      hasCloudName: !!cloudinaryCloudName,
      cloudName: cloudinaryCloudName,
      allEnvVars: {
        NEXT_PUBLIC_CLOUDINARY_API_KEY:
          !!process.env.NEXT_PUBLIC_CLOUDINARY_API_KEY,
        NEXT_PUBLIC_CLOUDINARY_CLOUD_NAME:
          !!process.env.NEXT_PUBLIC_CLOUDINARY_CLOUD_NAME,
      },
    });

    // Note: We don't need to check these for the fallback method
    // The fallback method uses /api/image/upload which handles server-side config

    // If we don't have the required environment variables, skip signature method
    // and go directly to fallback method
    if (!cloudinaryApiKey || !cloudinaryCloudName) {
      console.warn(
        'Cloudinary environment variables not configured, using fallback method',
      );
      try {
        setProgress(25);
        const compressedFile = await compressImage(file);
        setProgress(50);
        const result = await uploadFileDirect(compressedFile, options);
        setProgress(100);
        return result;
      } catch (compressionError) {
        console.warn(
          'Image compression failed, using original file:',
          compressionError,
        );
        setProgress(50);
        const result = await uploadFileDirect(file, options);
        setProgress(100);
        return result;
      }
    }

    try {
      const MAX_FILE_SIZE = 5 * 1024 * 1024; // 5MB
      if (file.size > MAX_FILE_SIZE) {
        throw new Error(
          `File size cannot exceed ${MAX_FILE_SIZE / (1024 * 1024)}MB`,
        );
      }

      let compressedFile: File;
      try {
        compressedFile = await compressImage(file);
        setProgress(25);
      } catch (compressionError) {
        console.warn(
          'Image compression failed, using original file:',
          compressionError,
        );
        compressedFile = file;
        setProgress(25);
      }

      setProgress(50);

      // Retry mechanism for signature generation
      const maxRetries = 3;
      const retryDelay = 1000; // 1 second
      let signatureData;

      for (let attempt = 1; attempt <= maxRetries; attempt++) {
        try {
          const signatureResponse = await api.post('/api/image/sign', {
            folder: options.folder,
            public_id: options.public_id,
            resource_type: options.resource_type || 'auto',
            file_size: compressedFile.size,
          });

          signatureData = signatureResponse.data;
          break; // Success - break out of retry loop
        } catch (error: any) {
          console.error(
            `Signature generation failed (attempt ${attempt}/${maxRetries}):`,
            {
              error: error.message,
              status: error.response?.status,
              statusText: error.response?.statusText,
              data: error.response?.data,
              config: {
                url: error.config?.url,
                method: error.config?.method,
                data: error.config?.data,
              },
            },
          );

          if (attempt === maxRetries) {
            // Final attempt failed - try alternative upload method
            console.warn('Signature API failed, attempting fallback upload...');
            const fallbackResult = await uploadFileDirect(
              compressedFile,
              options,
            );
            setProgress(100);
            return fallbackResult;
          } else {
            // Wait before retrying
            await new Promise((resolve) => setTimeout(resolve, retryDelay));
          }
        }
      }
      setProgress(75);

      const formData = new FormData();
      formData.append('file', compressedFile);
      formData.append('signature', signatureData.signature);
      formData.append('timestamp', signatureData.timestamp.toString());
      formData.append('folder', signatureData.folder);
      formData.append(
        'api_key',
        process.env.NEXT_PUBLIC_CLOUDINARY_API_KEY || '',
      );

      if (signatureData.resourceType) {
        formData.append('resource_type', signatureData.resourceType);
      }

      if (signatureData.publicId) {
        formData.append('public_id', signatureData.publicId);
      }

      // Validate signature data before upload
      if (
        !signatureData.signature ||
        !signatureData.timestamp ||
        !signatureData.cloudName
      ) {
        throw new Error('Invalid signature data received from server');
      }

      const uploadResponse = await fetch(
        `https://api.cloudinary.com/v1_1/${signatureData.cloudName}/image/upload`,
        {
          method: 'POST',
          body: formData,
        },
      );

      if (!uploadResponse.ok) {
        let errorMessage = 'Upload failed';
        try {
          const errorData = await uploadResponse.json();
          errorMessage =
            errorData.error?.message || errorData.message || errorMessage;
        } catch (parseError) {
          errorMessage = `HTTP ${uploadResponse.status}: ${uploadResponse.statusText}`;
        }
        throw new Error(errorMessage);
      }

      const result: CloudinaryUploadResult = await uploadResponse.json();

      setProgress(100);
      return result;
    } catch (err) {
      const errorMessage = err instanceof Error ? err.message : 'Upload failed';
      setError(errorMessage);
      console.error('Upload error:', err);
      throw err;
    } finally {
      setUploading(false);
    }
  };

  const uploadAndReplace = async (
    file: File,
    options: UploadOptions,
    oldImageUrl?: string,
  ): Promise<CloudinaryUploadResult> => {
    const uploadResult = await uploadFile(file, options);

    if (uploadResult && oldImageUrl) {
      try {
        await api.delete('/api/image/delete', {
          data: { imageUrl: oldImageUrl },
        });
      } catch (deleteError) {
        console.warn('Failed to delete old image:', deleteError);
      }
    }

    return uploadResult;
  };

  return { uploadFile, uploadAndReplace, uploading, progress, error };
};
