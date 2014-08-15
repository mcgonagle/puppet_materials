import "classes/*.pp"
import "defines/*.pp"

class supervisor {

 package { "supervisor": ensure => latest }

 file { "/etc/supervisord.conf":
  content => template('supervisor/supervisord.conf.erb'),
  owner => "root", group => "root", mode => "0644", 
  require => Package["supervisor"], }

 service { "supervisord":
  enable    => true,
  ensure    => running,
  subscribe => File["/etc/supervisord.conf"],
  require => [ File["/etc/supervisord.conf"], Package["supervisor"] ],
  }


}#end of supervisor class
