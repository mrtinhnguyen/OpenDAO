import Link from 'next/link';
import { useRouter } from 'next/router';
import React, { useEffect } from 'react';

import { Default } from '@/layouts/Default';
import { Meta } from '@/layouts/Meta';
import { useUser } from '@/store/user';

export default function Blocked() {
  const { user } = useUser();
  const router = useRouter();

  useEffect(() => {
    if (user && !user?.isBlocked) {
      router.push('/');
    }
  }, [user]);

  return (
    <Default
      meta={
        <Meta
          title="Blocked | OpenDAO AI"
          description="Explore the latest bounties on OpenDAO AI, offering opportunities in the crypto space across Design, Development, and Content."
          canonical="https://opendao.ai"
        />
      }
    >
      <div className="mx-auto mt-10 max-w-[800px] px-4">
        <p className="text-center text-3xl font-medium text-slate-600">
          Your access to OpenDAO AI has been restricted. Please get in touch
          with{' '}
          <Link className="text-brand-purple" href="mailto:support@opendao.ai">
            support@opendao.ai
          </Link>{' '}
          if you have any questions for more information.
        </p>
      </div>
    </Default>
  );
}
