import { api } from '@/lib/api';

const allowedNewUserRedirections = ['/signup', '/new/sponsor'];

interface CreateUserResponse {
  message: string;
  created: boolean;
}

export async function handleUserCreation(email: string): Promise<boolean> {
  const maxRetries = 3;
  const retryDelay = 2000; // 2 seconds - increased for auth timing

  // Add initial delay to ensure authentication is fully processed
  await new Promise((resolve) => setTimeout(resolve, 1000));

  for (let attempt = 1; attempt <= maxRetries; attempt++) {
    try {
      const response = await api.post<CreateUserResponse>('/api/user/create', {
        email,
      });

      const { created } = response.data;

      if (created) {
        if (
          allowedNewUserRedirections?.some((s) =>
            window.location.pathname.startsWith(s),
          )
        ) {
          window.location.reload();
        }
      }

      return true;
    } catch (error: any) {
      if (error.response?.status === 409) {
        console.error(
          'User exists with different authentication method:',
          error.response.data.error,
        );
        return false;
      }

      if (error.response?.status === 401 && attempt < maxRetries) {
        console.warn(
          `Authentication failed, retrying in ${retryDelay}ms... (attempt ${attempt}/${maxRetries})`,
        );
        await new Promise((resolve) => setTimeout(resolve, retryDelay));
        continue;
      }

      if (attempt === maxRetries) {
        console.error('All attempts failed for user creation:', error);
        return false;
      }

      console.error('Error handling user creation:', error);
      return false;
    }
  }

  return false;
}
