'use client';

import { usePrivy } from '@privy-io/react-auth';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import axios from 'axios';
import { useRouter } from 'next/router';
import { useEffect } from 'react';
import { getCookie, removeCookie, setCookie } from 'typescript-cookie';

import { useForcedProfileRedirect } from '@/hooks/use-forced-profile-redirect';
import { type User } from '@/interface/user';
import { api } from '@/lib/api';
// PostHog temporarily disabled - using mock
import posthog from '@/lib/posthog-mock';

export const USER_ID_COOKIE_NAME = 'user-id-hint';
const COOKIE_OPTIONS = {
  path: '/',
  secure: process.env.NODE_ENV === 'production',
  expires: 30,
  sameSite: 'lax' as const,
};

export const useUser = () => {
  const { authenticated, ready, logout } = usePrivy();
  const router = useRouter();

  const {
    data: user,
    error,
    refetch,
    isLoading,
  } = useQuery({
    queryKey: ['user'],
    queryFn: async () => {
      try {
        const { data: fetchedUser } = await api.get<User>('/api/user/');

        if (fetchedUser?.id) {
          const currentUserId = getCookie(USER_ID_COOKIE_NAME);
          if (fetchedUser.id !== currentUserId) {
            setCookie(USER_ID_COOKIE_NAME, fetchedUser.id, COOKIE_OPTIONS);
          }
        }

        if (fetchedUser?.isBlocked && !router.pathname.includes('/blocked')) {
          router.push('/blocked');
        }
        return fetchedUser;
      } catch (error) {
        if (ready && authenticated) {
          if (axios.isAxiosError(error)) {
            if (error.response?.status === 401) {
              console.warn('User request returned 401, logging out.');
              removeCookie(USER_ID_COOKIE_NAME, { path: '/' });
              await logout();
              if (
                typeof posthog !== 'undefined' &&
                posthog._isIdentified &&
                posthog._isIdentified()
              ) {
                try {
                  posthog.reset();
                } catch (error) {
                  console.warn('PostHog reset failed:', error);
                }
              }
            }
          }
        }
        throw error;
      }
    },
    enabled: authenticated && ready,
    staleTime: 10 * 60 * 1000,
    gcTime: 15 * 60 * 1000,
    refetchOnWindowFocus: true,
    refetchOnReconnect: true,
  });

  useForcedProfileRedirect({
    user: user || null,
    isUserLoading: !ready || isLoading,
  });

  useEffect(() => {
    if (isLoading || !ready) return;

    if (!user) {
      if (
        typeof posthog !== 'undefined' &&
        posthog._isIdentified &&
        posthog._isIdentified()
      ) {
        try {
          posthog.reset();
        } catch (error) {
          console.warn('PostHog reset failed:', error);
        }
      }
      return;
    }

    const profileComplete = user.isTalentFilled || !!user.currentSponsorId;

    if (profileComplete && typeof posthog !== 'undefined') {
      try {
        const alreadyIdentified =
          posthog._isIdentified && posthog._isIdentified();
        const sameUser =
          posthog.get_distinct_id &&
          posthog.get_distinct_id() === String(user.id);

        if (!alreadyIdentified || !sameUser) {
          posthog.identify && posthog.identify(user.id, { email: user.email });
        }
      } catch (error) {
        console.warn('PostHog identify failed:', error);
      }
    }
  }, [user, isLoading, ready]);

  return {
    user: user || null,
    isLoading: !ready || isLoading,
    error,
    refetchUser: refetch,
  };
};

export const useUpdateUser = () => {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (userData: Partial<User>) =>
      api.post<User>('/api/user/update/', userData),
    onSuccess: (response) => {
      const updatedUser = response.data;
      if (updatedUser) {
        queryClient.setQueryData(['user'], updatedUser);

        const currentUserId = getCookie(USER_ID_COOKIE_NAME);
        if (updatedUser.id !== currentUserId) {
          setCookie(USER_ID_COOKIE_NAME, updatedUser.id, COOKIE_OPTIONS);
        }
      }
    },
  });
};

export const useLogout = () => {
  const { logout } = usePrivy();
  const queryClient = useQueryClient();

  return async () => {
    removeCookie(USER_ID_COOKIE_NAME, { path: '/' });

    await logout();

    queryClient.clear();
    if (posthog._isIdentified && posthog._isIdentified()) {
      try {
        posthog.reset();
      } catch (error) {
        console.warn('PostHog reset failed:', error);
      }
    }

    window.location.reload();
  };
};
