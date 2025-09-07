import { useQuery } from '@tanstack/react-query';
import { useAtom } from 'jotai';
import { ExternalLink } from 'lucide-react';
import Head from 'next/head';
import Link from 'next/link';
// PostHog temporarily disabled - using mock
import posthog from '@/lib/posthog-mock';
import { useEffect, useState } from 'react';

import { EmptySection } from '@/components/shared/EmptySection';
import { LoadingSection } from '@/components/shared/LoadingSection';
import { useUser } from '@/store/user';
import { getURLSanitized } from '@/utils/getURLSanitized';
import { getURL } from '@/utils/validUrl';

import { ApplicationActionButton } from '@/features/grants/components/ApplicationActionButton';
import { ApplicationStats } from '@/features/grants/components/ApplicationStats';
import { ApprovalStages } from '@/features/grants/components/ApprovalStages';
import { GrantsHeader } from '@/features/grants/components/GrantsHeader';
import { GrantStats } from '@/features/grants/components/GrantStats';
import { userApplicationQuery } from '@/features/grants/queries/user-application';
import { type GrantWithApplicationCount } from '@/features/grants/types';
import { LiveGrants } from '@/features/home/components/LiveGrants';
import { ExtraInfoSection } from '@/features/listings/components/ListingPage/ExtraInfoSection';
import { grantSnackbarAtom } from '@/features/navbar/components/GrantSnackbar';

import { Default } from './Default';

interface GrantPageProps {
  grant: GrantWithApplicationCount | null;
  children: React.ReactNode;
}
export function GrantPageLayout({
  grant: initialGrant,
  children,
}: GrantPageProps) {
  const [grant] = useState<typeof initialGrant>(initialGrant);
  const encodedTitle = encodeURIComponent(initialGrant?.title || '');

  const [, setGrantSnackbar] = useAtom(grantSnackbarAtom);
  const { user } = useUser();

  const iterableSkills = initialGrant?.skills?.map((e) => e.skills) ?? [];

  const { data: application } = useQuery({
    ...userApplicationQuery(initialGrant?.id ?? ''),
    enabled: !!user?.id,
  });

  let isApproved = false;
  if (application && application.applicationStatus === 'Approved') {
    isApproved = true;
  }

  const isST =
    initialGrant?.isNative &&
    initialGrant?.airtableId &&
    !initialGrant?.title?.toLowerCase().includes('coindcx');

  useEffect(() => {
    if (initialGrant) {
      setGrantSnackbar({
        isPublished: !!initialGrant?.isPublished,
      });
    }
  }, [initialGrant]);

  return (
    <Default
      meta={
        <Head>
          <title>{`${initialGrant?.title || 'Grant'} | Superteam Earn`}</title>
          <meta
            property="og:title"
            content={`${initialGrant?.title || 'Grant'} | Superteam Earn`}
          />
          <meta
            property="og:image"
            content={`${getURL()}api/dynamic-og/grant/?title=${encodedTitle}&token=${initialGrant?.token}&sponsor=${initialGrant?.sponsor?.name}&logo=${initialGrant?.sponsor?.logo}&minReward=${initialGrant?.minReward}&maxReward=${initialGrant?.maxReward}&isSponsorVerified=${initialGrant?.sponsor?.isVerified}`}
          />
          <meta
            name="twitter:title"
            content={`${initialGrant?.title || 'Grant'} | Superteam Earn`}
          />
          <meta
            name="twitter:image"
            content={`${getURL()}api/dynamic-og/grant/?title=${encodedTitle}&token=${initialGrant?.token}&sponsor=${initialGrant?.sponsor?.name}&logo=${initialGrant?.sponsor?.logo}&minReward=${initialGrant?.minReward}&maxReward=${initialGrant?.maxReward}&isSponsorVerified=${initialGrant?.sponsor?.isVerified}`}
          />
          <meta name="twitter:card" content="summary_large_image" />
          <meta property="og:image:width" content="1200" />
          <meta property="og:image:height" content="630" />
          <meta property="og:image:alt" content="Superteam Grant" />
          <meta charSet="UTF-8" key="charset" />
          <meta
            name="viewport"
            content="width=device-width, initial-scale=1, maximum-scale=1"
            key="viewport"
          />
        </Head>
      }
    >
      <div className="bg-white">
        {grant === null && <LoadingSection />}
        {grant !== null && !grant?.id && <EmptySection />}
        {grant !== null && !!grant?.id && (
          <div className="mx-auto w-full px-2 lg:px-6">
            <div className="mx-auto w-full max-w-7xl">
              <GrantsHeader
                grant={grant}
                title={grant?.title ?? ''}
                sponsor={grant?.sponsor}
                status={grant?.status}
                region={grant?.region}
                slug={grant?.slug}
                references={grant.references}
                isPublished={grant.isPublished || false}
                isApproved={isApproved}
              />

              <div className="mb-10 flex max-w-6xl flex-col items-center justify-center gap-0 md:flex-row md:items-start md:justify-between md:gap-4">
                <div className="static top-14 w-full md:sticky md:w-auto">
                  <div className="flex flex-col gap-2">
                    <div className="flex w-full flex-col justify-center rounded-xl bg-white py-4 md:w-[22rem]">
                      {isApproved && application && isST ? (
                        <ApplicationStats
                          application={application}
                          grant={grant}
                        />
                      ) : (
                        <GrantStats grant={grant} />
                      )}
                      <div className="hidden w-full md:flex">
                        <ApplicationActionButton grant={grant} />
                      </div>
                      {isApproved && application && isST ? (
                        <ApprovalStages
                          application={application}
                          grant={grant}
                        />
                      ) : (
                        <>
                          <div>
                            <ExtraInfoSection
                              skills={iterableSkills}
                              region={grant.region}
                              requirements={grant.requirements}
                              pocSocials={grant.pocSocials}
                              isGrant
                            />
                          </div>
                          <div className="hidden w-full pt-8 md:block">
                            <LiveGrants
                              excludeIds={grant.id ? [grant.id] : undefined}
                            >
                              <p className="h-full text-start text-sm font-semibold text-slate-600">
                                LIVE GRANTS
                              </p>
                            </LiveGrants>
                          </div>
                        </>
                      )}
                    </div>
                  </div>
                </div>
                <div className="flex w-full flex-col gap-8 border-slate-100 px-2 md:border-l md:px-5">
                  {children}
                  <div className="flex flex-col items-start md:hidden">
                    <p className="mb-1.5 h-full text-center text-xs font-semibold text-slate-600">
                      SKILLS NEEDED
                    </p>
                    <div className="flex flex-wrap gap-3">
                      {iterableSkills?.map((skill) => (
                        <div
                          className="m-0 rounded-sm bg-slate-100 px-4 py-1 text-sm font-medium"
                          key={skill}
                        >
                          <p className="text-xs text-slate-600">{skill}</p>
                        </div>
                      ))}
                    </div>
                  </div>
                  {initialGrant?.pocSocials && (
                    <div className="flex w-full flex-col items-start text-sm md:hidden">
                      <p className="h-full text-center font-semibold text-slate-600">
                        CONTACT
                      </p>
                      <p>
                        <Link
                          className="ph-no-capture font-medium text-[#64768b]"
                          href={getURLSanitized(initialGrant.pocSocials)}
                          onClick={() => posthog.capture('reach out_listing')}
                        >
                          Reach out
                          <ExternalLink className="mx-1 mb-1 inline text-[#64768b]" />
                        </Link>
                        <span className="text-slate-500">
                          if you have any questions about this listing
                        </span>
                      </p>
                    </div>
                  )}
                </div>
              </div>
            </div>
            <div className="sticky bottom-14 z-40 mb-10 w-full border-t-1 border-slate-100 bg-white py-1 md:hidden">
              <ApplicationActionButton grant={grant} />
            </div>
          </div>
        )}
      </div>
    </Default>
  );
}
