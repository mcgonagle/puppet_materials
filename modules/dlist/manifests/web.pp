# Class: dlist::web
#
# This module manages dlist::web
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
class dlist::web {

 #dlist properties file
  file {"/usr/local/etc":
    ensure => directory,
    owner => "root", group => "root", mode => "0755", }

  file { "/usr/local/etc/dlist.properties":
    source => [
      "puppet:///modules/dlist/dlist.properties/dlist.properties.${zone}",
      "puppet:///modules/dlist/dlist.properties/dlist.properties.pd", ],
    owner => "root", group => "root", mode => "0755", 
    require => File["/usr/local/etc"], }

  file { "/usr/local/etc/dlist-appserver.properties":
    source => [
      "puppet:///modules/dlist/dlist-appserver.properties.${zone}",
      "puppet:///modules/dlist/dlist-appserver.properties", ],
    owner => "root", group => "root", mode => "0755", 
    require => File["/usr/local/etc"], }

  #the file stanza below pushes out a the correct zone for a file
  file { "/usr/local/etc/apns.p12":
    source => [
     "puppet:///modules/dlist/apns/apns.p12.${zone}",
     "puppet:///modules/dlist/apns/apns.p12.pd", ],
    owner => "root", group => "root", mode => "0755",
    require => File["/usr/local/etc"], } 

}
