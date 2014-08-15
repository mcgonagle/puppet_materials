class motd {
  tag('test')
  file {'/etc/motd':
    ensure => file,
    content => "Hello Puppetmaster. I am ${hostname}, nodetype ${nodetype}"
  }
}
