# Class: rsnapshot
#
# Manages rsnapshot software 
# Include it to install and run rsnapshot with default settings
#
# Usage:
# include rsnapshot
import "defines/*.pp"

class rsnapshot {
    package {"rsnapshot": ensure => latest }
    $rsnapshot_template = extlookup("${role}::rsnapshot::template","rsnapshot.conf.d.erb")

    file{"/etc/rsnapshot.conf":
      content => template("rsnapshot/rsnapshot.conf.erb"),
      owner => "root", group => "root", mode => "0644",
      require => Package["rsnapshot"], }

    file{"/etc/rsnapshot.conf.d":
      ensure => directory,
      require => File["/etc/rsnapshot.conf"],}

    file{"/etc/rsnapshot.conf.d/system_rsnapshot.conf":
      ensure => present,
      content => template("rsnapshot/rsnapshot.conf.d/${rsnapshot_template}"),
      owner => "root", group => "root", mode => "0644", 
      require => File["/etc/rsnapshot.conf.d"], }

    cron {"rsnapshot-hourly":
      command => "/usr/bin/rsnapshot -c /etc/rsnapshot.conf hourly",
      user => "root",
      minute => 0,
      }

    cron {"rsnapshot-daily":
      command => "/usr/bin/rsnapshot -c /etc/rsnapshot.conf daily",
      user => "root",
      hour => 3,
      minute => 30,
      }


}#end of class rsnapshot
