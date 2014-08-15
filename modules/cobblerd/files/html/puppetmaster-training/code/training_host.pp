host { 'training.puppetlabs.com':
  ensure       => 'present',
  host_aliases => 'labs',
  ip           => '172.16.238.131',
}
