# Class: vhosts
#
# Manages vhosts
# Include it to install and run apache with default settings
#
# Usage:
# include vhosts


import "classes/*.pp"
import "defines/*.pp"
import "classes/wordpress/*.pp"

class vhosts {
  include httpd
  #include vhosts::sandboxes
  file {"/etc/httpd/vhosts.d":
    ensure  => directory,
    owner   => root, group => root, mode => "0755",
    require => Package["httpd"], }

  file { "/etc/httpd/conf.d/vhosts.d.conf":
    content => "NameVirtualHost *:80
                NameVirtualHost *:443
                Include vhosts.d/*.conf",
    owner   => "root", group => "root", mode => "0755",
    require => File["/etc/httpd/vhosts.d"], }
}#end of apache::vhosts
