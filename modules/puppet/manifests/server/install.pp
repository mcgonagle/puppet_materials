# Class: puppet::server::install
#
# This module manages puppet::server::install
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
class puppet::server::install {
	package {"ruby-devel": ensure => installed }
	package {"gcc": ensure => installed }
	package {"gcc-c++": ensure => installed }
	package {"make": ensure => installed }
	package {"httpd-devel": ensure => installed }
	package {"apr-devel": ensure => installed }
	package {"mod_ssl": ensure => installed }
	package { 'rubygem-rack': ensure => '1.0.1-2.el5', }
	package { 'rubygem-rake': ensure => '0.8.7-2.el5', }
	package { 'rubygem-fastthread': ensure => '1.0.7-1.el5', }
	package { 'rubygem-passenger': ensure => '2.2.11-3.el5', }
	package { 'rails': provider => 'gem',  ensure => '2.2.2', }
	package { 'puppet-server': ensure => '2.6.8-0.5.el5', }

  exec {"/usr/bin/passenger-install-apache2-module":
    creates => "/usr/lib/ruby/gems/1.8/gems/passenger-2.2.11/ext/apache2/mod_passenger.so",
    require => Package["rubygem-passenger"], }

	package { 'mysql': ensure => latest, }
	package { 'mysql-devel': ensure => latest, }
	package { 'mysql-server': ensure => latest, }
	package { 'mysql-gem': name => 'mysql', provider => 'gem',  ensure => latest, }


}
