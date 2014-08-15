Package["apache"] -> File["/var/www"] ~> Service["httpd"]

Service["httpd"] <~ File["/var/www"] <- Package["apache"]

file { "/var/www": ensure => present } -> service { httpd: ensure => running }
