host { 'kermit.puppetlabs.com':
  ensure        => present,
  host_aliases  => 'kermit',
  ip            => '172.16.238.131',
}
host { 'piggy.puppetlabs.com':
  ensure       => present,
  host_aliases => ['piggy', 'missy'],
  ip           => '172.16.238.132',
}
host { 'oscar.puppetlabs.com':
  ensure => absent,
}
