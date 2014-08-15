class pecl::apc inherits pecl {
  require php
 	package { "php-pecl-apc": ensure => latest }

   $document_root = $role ? {
      /www/ => "/usr/local/src/manhunt",
      default => "/var/www/html", 
    }#end of selector
  
  file {"/etc/php.d/apc.ini":
    content => template("pecl/php_d_apc.ini.erb"),
    owner => "root", group => "root", mode => "0755",
    require => Package["php-pecl-apc"], }

  file{"${document_root}/apc":
    ensure => directory,
    owner => "build", group => "build", mode => "0755",
    require => Package["php-pecl-apc"], }

  file{"${document_root}/apc/apc_info.php":
    source => "puppet:///modules/pecl/php_apc/apc_info.php",
    owner => "build", group => "build", mode => "0755",
    require => File["${document_root}/apc"], }

  file{"/usr/share/munin/plugins/php_apc_":
    source => "puppet:///modules/pecl/php_apc/php_apc_",
    owner => "build", group => "build", mode => "0755", 
    require => File["${document_root}/apc/apc_info.php"], }

  file{"/etc/munin/plugin-conf.d/php_apc":
    content => inline_template("[php_apc_*]
user root
env.url http://${fqdn}/apc/apc_info.php?auto"),
    owner => "root", group => "root", mode => "0644", 
    require => [File["/usr/share/munin/plugins/php_apc_"],
                File["${document_root}/apc"], 
                File["${document_root}/apc/apc_info.php"]], }
  
  file{"/etc/munin/plugins/php_apc_files":
    ensure => link,
    target => "/usr/share/munin/plugins/php_apc_",
    require => File["/usr/share/munin/plugins/php_apc_"], } 

  file{"/etc/munin/plugins/php_apc_fragmentation":
    ensure => link,
    target => "/usr/share/munin/plugins/php_apc_",
    require => File["/usr/share/munin/plugins/php_apc_"], } 

  file{"/etc/munin/plugins/php_apc_hit_miss":
    ensure => link,
    target => "/usr/share/munin/plugins/php_apc_",
    require => File["/usr/share/munin/plugins/php_apc_"], } 

  file{"/etc/munin/plugins/php_apc_purge":
    ensure => link,
    target => "/usr/share/munin/plugins/php_apc_",
    require => File["/usr/share/munin/plugins/php_apc_"], } 

  file{"/etc/munin/plugins/php_apc_rates":
    ensure => link,
    target => "/usr/share/munin/plugins/php_apc_",
    require => File["/usr/share/munin/plugins/php_apc_"], } 

  file{"/etc/munin/plugins/php_apc_usage":
    ensure => link,
    target => "/usr/share/munin/plugins/php_apc_",
    require => File["/usr/share/munin/plugins/php_apc_"], } 

}#end of class pear::apc
