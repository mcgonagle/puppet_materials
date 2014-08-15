# Class: resin::config
#
# This module manages resin
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
class resin::config {

 	file {"/etc/profile.d/resin.sh":
        	source => "puppet:///modules/resin/resin.sh",
        	owner => "root", group => "root", mode => 0755,
        	ensure => present, 
        	require => Class["resin::install"], }

  	#startup script for resin
    	file {"/etc/init.d/resin":
        	source => "puppet:///modules/resin/resin",
        	owner => "root", group => "root", mode => 0755,
        	ensure => present, 
        	require => Class["resin::install"], }
  

 	file {"/opt/resin/conf/resin.conf":
        	content => template("resin/resin.conf.erb"),
        	owner => "root", group => "root", mode => 0644,
        	ensure => present, 
        	require => Class["resin::install"], }

	file {"/opt/resin/keys":
        	source => "puppet:///modules/resin/keys",
        	owner => "root", group => "root", mode => 0644,
        	recurse => true,
        	ensure => present, 
        	require => Class["resin::install"], }

	file {"/opt/resin/lib/${resin::params::c3p0_file}":
        	source => "puppet:///modules/resin/lib/${resin::params::c3p0_file}",
        	owner => "root", group => "root", mode => 0644,
        	recurse => true,
        	ensure => present, 
        	require => Class["resin::install"], }

	file {"/opt/resin/lib/${resin::params::mysql_connector_file}":
        	source => "puppet:///modules/resin/lib/${resin::params::mysql_connector_file}",
        	owner => "root", group => "root", mode => 0644,
        	recurse => true,
        	ensure => present, 
        	require => Class["resin::install"], }

	file {"/opt/resin/lib/${resin::params::primrose_file}":
        	source => "puppet:///modules/resin/lib/${resin::params::primrose_file}",
        	owner => "root", group => "root", mode => 0644,
        	recurse => true,
        	ensure => present, 
        	require => Class["resin::install"], }

	#dlist properties file
	file {"/usr/local/etc":
		ensure => directory,
		owner => "root", group => "root", mode => "0755", }

	file { "/usr/local/etc/dlist.properties":
		source => [
		"puppet:///modules/resin/dlist.properties/dlist.properties.${zone}",
		"puppet:///modules/resin/dlist.properties/dlist.properties.pd",
		],
		owner => "root", group => "root", mode => "0755",
		require => File["/usr/local/etc"], }

	#the file stanza below pushes out a the correct zone
	#for a file	
	file { "/usr/local/etc/apns.p12":
		source => [
		"puppet:///modules/resin/apns/apns.p12.${zone}",
		"puppet:///modules/resin/apns/apns.p12.pd",
		],
		owner => "root", group => "root", mode => "0755",
		require => File["/usr/local/etc"], }

	#install redirect file
	file { "/opt/resin/conf/redirect.config.erb":
		content => template("resin/redirect.config.erb"),
		owner => "root", group => "root", mode => "0644",
 		require => Class["resin::install"], }


	#dlist deploy directory
	file {"/usr/local/stage":
		ensure => directory,
		owner => "root", group => "root", mode => "0755", }


}#end of class resin::config
