// Mock PostHog object to temporarily disable all PostHog functionality
export const posthog = {
  _isIdentified: () => false,
  get_distinct_id: () => null,
  identify: (..._args: any[]) => {},
  reset: () => {},
  capture: () => {},
  alias: () => {},
  group: () => {},
  isFeatureEnabled: () => false,
  getFeatureFlag: () => null,
  onFeatureFlags: () => {},
  reloadFeatureFlags: () => {},
  debug: () => {},
  opt_in_capturing: () => {},
  opt_out_capturing: () => {},
  has_opted_in_capturing: () => false,
  has_opted_out_capturing: () => false,
  clear_opt_in_out_capturing: () => {},
  people: {
    set: () => {},
    set_once: () => {},
    increment: () => {},
    append: () => {},
    union: () => {},
    track_charge: () => {},
    clear_charges: () => {},
    delete_user: () => {},
  },
  __loaded: false,
};

// Export as default for compatibility
export default posthog;
