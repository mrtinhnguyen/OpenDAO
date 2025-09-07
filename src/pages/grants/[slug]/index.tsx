import type { GetServerSideProps } from 'next';
// PostHog temporarily disabled - using mock
import posthog from '@/lib/posthog-mock';
import React, { useEffect, useState } from 'react';

import { GrantPageLayout } from '@/layouts/Grants';
import { api } from '@/lib/api';
import { getURL } from '@/utils/validUrl';

import { GrantsPop } from '@/features/conversion-popups/components/GrantsPop';
import { type GrantWithApplicationCount } from '@/features/grants/types';
import { DescriptionUI } from '@/features/listings/components/ListingPage/DescriptionUI';

interface InitialGrant {
  grant: GrantWithApplicationCount;
}

function Grants({ grant: initialGrant }: InitialGrant) {
  const [grant] = useState<typeof initialGrant>(initialGrant);

  useEffect(() => {
    posthog.capture('open_grant');
  }, []);

  return (
    <GrantPageLayout grant={grant}>
      <GrantsPop />
      <DescriptionUI description={(grant?.description as string) ?? ''} />
    </GrantPageLayout>
  );
}

export const getServerSideProps: GetServerSideProps = async (context) => {
  const { slug } = context.query;

  let grantData;
  try {
    const grantDetails = await api.get(`${getURL()}api/grants/${slug}`);
    grantData = grantDetails.data;
  } catch (e) {
    console.error(e);
    grantData = null;
  }

  return {
    props: {
      grant: grantData,
    },
  };
};
export default Grants;
