class passenger {
 package { "gcc-c++": ensure => latest,}
 package { "ruby-devel": ensure => latest,}
 package { "mod_ssl": ensure => latest,}
 package { "curl-devel": ensure => latest,}
 package { "openssl-devel": ensure => latest,}
 package { "zlib-devel": ensure => latest,}
 package { "rubygem-activerecord": ensure => latest,}
 package { "rubygem-passenger": ensure => latest, }

 include httpd::devel
 include gems

 exec {"/usr/lib/ruby/gems/1.8/gems/passenger-2.2.11/bin/passenger-install-apache2-module -a":
      path => "/usr/bin:/usr/sbin:/bin:/usr/lib/ruby/gems/1.8/gems/passenger-2.2.11/bin",
      onlyif => "! /usr/bin/test -f /usr/lib/ruby/gems/1.8/gems/passenger-2.2.11/ext/apache2/mod_passenger.so",
      subscribe => Package["rubygem-passenger"],
      require => Package["rubygem-passenger"], 
      }#end of exec

 file{"/etc/httpd/conf.d/puppetmasterd.conf":
      content => template("passenger/puppetmasterd.conf.erb"),
      owner => "root", group => "root", mode => "0644", 
      require => [ Package["rubygem-passenger"], Package["httpd"]], }

 file {  "/etc/puppet/rack/":,
          ensure => directory,
          owner => "puppet", group => "puppet", mode => "0644",
	        require => Package["puppet-server"], }

 file {  "/etc/puppet/rack/public":,
          ensure => directory,
          owner => "puppet", group => "puppet", mode => "0644",
	        require => [Package["puppet-server"],File["/etc/puppet/rack"]], }

 file { "/etc/puppet/rack/public/RPC2":,
          ensure => directory,
          owner => "puppet", group => "puppet", mode => "0644",
	        require => [Package["puppet-server"],File["/etc/puppet/rack/public"]], }

 file { "/etc/puppet/rack/config.ru":
        source => "puppet:///modules/puppet/config.ru",
        owner => "puppet", group => "puppet", mode => "0644",
	      require => [Package["puppet-server"], File["/etc/puppet/rack"]], }
 
 exec {"chown -R puppet:puppet /etc/puppet/rack":
	      path => ["/bin", "/usr/bin", "/usr/sbin/" ],
	      unless =>  "/bin/sh -c '[ $(/usr/bin/stat -c %U /etc/puppet/rack/config.ru) == puppet ]'",
	      require => File["/etc/puppet/rack/config.ru"], 
        subscribe => File["/etc/puppet/rack/config.ru"], }
}#end of class passenger
