# Class: role::www
#
# This module manages role::www
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class role::www {
  class { 'httpd':
      service_enable => "true",
      service_ensure => "running", }

  class { 'php': }
    
  #need to fixup the phpkb class
  #include phpkb
  include maxmind

  include vhost
  include vhost::manhunt
  
  include mount::mh::media

  #augeas definition which exports /var/log/httpd to logviewer*
  augeas{ "export /var/log/httpd" :
    context => "/files/etc/exports",
    changes => [
        "set dir[last()+1] /var/log/httpd",
        "set dir[last()]/client logviewer*.manhunt.net",
        "set dir[last()]/client/option[1] rw",
        "set dir[last()]/client/option[2] all_squash",
        "set dir[last()]/client/option[3] no_wdelay",
        "set dir[last()]/client/option[4] sync",
        "set dir[last()]/client/option[5] no_subtree_check",
        "set dir[last()]/client/option[6] anonuid=2001",
        "set dir[last()]/client/option[7] anongid=2001",
    ],
    onlyif => "match dir[. = '/var/log/httpd'] size == 0", }

  #crons
  include cron
  include cron::mh::v4_webroller
  include cron::mh::http_integrity_check

  #  This will need to be updated to be something appropriate
  cron{"remove billing logs":
     command => 'find /var/log/html -type f -mtime 7 -exec rm {} \;', 
     user => root,
     hour => [ '0-23' ], }

  #will need to double check this and make sure it is how we want to do it
  #going forward 
  file { "/usr/local/${product}/cron/hostchecker.pl":
    source => "puppet:///modules/cron/${product}_tools/tools/hostchecker.pl",
    owner => "root", group => "root", mode => "0755",
    require => Class["cron::config"], }

}#end of role::www
