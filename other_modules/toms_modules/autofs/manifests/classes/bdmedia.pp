# Class: autofs::bdmedia
#
# Manages autofs software 
# Include it to install and run autofs with default settings
#
# Usage:
# include autofs::bd_media

class autofs::bdmedia inherits autofs {
    common::line{"autofs_bdmedia":
      file => "/etc/auto.master",
      line => "/bdmedia   /etc/auto.bdmedia",
      ensure => present, 
      require => Package["autofs"], }
      #before => Service["autofs"], }

    file {"/bdmedia":
        ensure => directory,
	owner => "media", group => "media", mode => "2755", }

    file { "/etc/auto.bdmedia":
      content => inline_template("*          -fstype=nfs,rw,nosuid,soft     ass.v4.waltham.manhunt.net:/ifs/data/bdmedia"),
      owner => "root", group => "root", mode => "0644", 
      require => [ Package["autofs"], Package["portmap"], File["/bdmedia"]],
      before => [ Service["autofs"], Service["portmap"] ],
      notify => Service["autofs"], }

}#end of class autofs
