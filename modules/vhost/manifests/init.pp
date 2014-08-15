# Class: vhost
#
# This module manages vhost
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
class vhost {
  require httpd
  file {"/etc/httpd/vhosts.d":
    ensure  => directory,
    owner   => root, group => root, mode => "0755", }

  file { "/etc/httpd/conf.d/vhosts.d.conf":
    content => "NameVirtualHost *:80\nNameVirtualHost *:443\nInclude vhosts.d/*.conf\n",
    owner   => "root", group => "root", mode => "0644", 
    require => File["/etc/httpd/vhosts.d"], }

}
