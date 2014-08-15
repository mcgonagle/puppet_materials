case $operatingsystem {
  'macos': {
    $content = 'MacOS thinks different.'
  }
  'centos', 'rhel', 'oel': {
    $content = 'redhattish things are fun'
  }
  default: {
    $content = 'there are other operating systems too...'
  }
}

file{'/tmp/os':
  content => $content,
}
