 file { "/srv/dlicious":
       ensure => directory,
       source => "puppet:///modules/wordpress/wordpress",
       recurse => true,
       owner => "root", group => "root", mode => "0755", }
