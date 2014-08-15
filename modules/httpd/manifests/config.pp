# Class: httpd::config
#
# This module manages httpd::config
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
class httpd::config {

  file{"/etc/httpd/conf/httpd.conf":
    content => template("httpd/httpd.conf.erb"),
    owner => "root", group => "root", mode => "0644", 
    require => Class["httpd::install"], }

}
