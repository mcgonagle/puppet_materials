class vhosts::sandboxes inherits vhosts {

  file {"/etc/httpd/vhosts.d/extra":
    ensure  => directory,
    owner   => root, group => root, mode => "0777",
    require => [ Package["httpd"], File["httpd.conf"] ],
  }

  file {"/etc/httpd/vhosts.d/extra/sandboxes":
    ensure  => directory,
    owner   => root, group => root, mode => "0777",
    require => [ File["/etc/httpd/vhosts.d/extra"] ],
  }

  file { "/etc/httpd/vhosts.d/vhost-sandboxes.conf":
    content => "Include /etc/httpd/vhosts.d/extra/sandboxes-vhosts.conf",
    mode   => 644, owner => root, group => root,
    require => [
                 File["/etc/httpd/vhosts.d/extra"],
                 File["httpd.conf"] ],
    notify => Service["httpd"],
  }

  file { "/etc/httpd/vhosts.d/extra/sandboxes-vhosts.conf":
    content => "Include /etc/httpd/vhosts.d/extra/sandboxes/*-vhost.conf",
    mode   => 644, owner => root, group => root,
    require => [
                 File["/etc/httpd/vhosts.d/extra"],
                 File["/etc/httpd/vhosts.d/extra/sandboxes"],
                 File["httpd.conf"] ],
    notify => Service["httpd"],
  }
}#end of apache::vhosts::sandboxes class
