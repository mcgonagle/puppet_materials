# Module: resin
#
# Class: resin
#
# Description:
#       This class installs resin
#
# Defines:
#
# Variables:
#
# Facts:
#       None
#
#       
class resin {
    require sun-java
    require resin::params

    common::unarchive::tar-gz{"${resin::params::packagename}":
        file => "${resin::params::packagename}",
        untared_file => "${resin::params::untared_packagename}",
        module_url => "${resin::params::file_url}",
        destination => "${resin::params::file_destination}", }
        #before => [ File["resin.sh"], File["/opt/resin"] ], }
    
    file {"/etc/profile.d/resin.sh":
        source => "puppet:///modules/resin/resin.sh",
        owner => "root", group => "root", mode => 0755,
        ensure => present,
        alias  => "resin.sh", }

    file {"/opt/resin":
        ensure => link, 
        target => "/opt/${resin::params::untared_packagename}",
        require => Common::Unarchive::Tar-gz["${resin::params::packagename}"], }
    
    #startup script for resin
    file {"/etc/init.d/resin":
        source => "puppet:///modules/resin/resin",
        owner => "root", group => "root", mode => 0755,
        ensure => present,
        alias  => "resin-startup-script", }

    file {"/opt/resin/conf/resin.conf":
        content => template("resin/resin.conf.erb"),
        owner => "root", group => "root", mode => 0644, 
        ensure => present,
        alias  => "resin-config", }

    file {"/opt/resin/keys":
        source => "puppet:///modules/resin/keys",
        owner => "root", group => "root", mode => 0644, 
        recurse => true,
        ensure => present,
        alias  => "resin-keys", }
 
    file {"/usr/local/stage":
        ensure => directory,
        owner => "root", group => "root", mode => 0644, }

    #file {"/opt/resin/bin/httpd.sh":
    #    source => "puppet:///modules/resin/httpd.sh",
    #    #content => template("resin/httpd.sh"),
    #    owner => "root", group => "root", mode => 0755, 
    #    ensure => present,
    #    alias  => "httpd.sh", }

    #LoadModule caucho_module /usr/lib64/httpd/modules/mod_caucho.so
    #file {"/usr/lib64/httpd/modules/mod_caucho.so":
    #    source => "puppet:///modules/resin/mod_caucho.so",
    #    owner => "root", group => "root", mode => 0755,
    #    ensure => present,
    #    alias  => "mod_caucho", }

   service {'resin': 
        enable  => false, 
        ensure  => stopped, 
        hasstatus => true, 
        hasrestart => true, }
        #require => [ File["resin-startup-script"] ], }

}#class resin
