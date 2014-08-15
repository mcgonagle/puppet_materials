# Class: nfs::server
#
# Manages nfs server settings
#
# Usage:
# include nfs::server 
#
class nfs::server {

    # Load the variables used in this module. Check the params.pp file
    require nfs::params

    # Includes nfs base class 
    require nfs

    # Ubuntu/Debian have separate package for nfs server
    case $operatingsystem {
        debian,ubuntu: { 
           package { "nfs-server":
               name   => "nfs-kernel-server",
               ensure => present,
           }
        }
    }
    
    service { "nfs":
        name       => "${nfs::params::servicename}",
        ensure     => running,
        enable     => true,
        hasrestart => true,
        hasstatus  => true,
        require    => Package["nfs"],
        subscribe  => File["exports"],
    }

    file { "exports":
        path    => "${nfs::params::configfile}",
        mode    => "${nfs::params::configfile_mode}",
        owner   => "${nfs::params::configfile_owner}",
        group   => "${nfs::params::configfile_group}",
        require => Package["nfs"],
        ensure  => present,
    }

    # Include extended classes, if relevant variables are defined
    if $puppi == "yes" { include nfs::puppi }
    if $backup == "yes" { include nfs::backup }
    if $monitor == "yes" { include nfs::monitor }
    if $firewall == "yes" { include nfs::firewall }

    # Include project specific class for server if $my_project is set
    if $my_project { include "nfs::${my_project}::server" }


# TODO : Add extra services (statd, gss, lockd...)

}
