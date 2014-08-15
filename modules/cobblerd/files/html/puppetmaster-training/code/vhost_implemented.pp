vhost { 'training.puppetlabs.net':
  port    => '8080',
  require => Package['httpd'],
  notify  => Service['httpd'],
}
