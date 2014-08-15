class tomcat::config {
   require java

   file{"/opt/tomcat":
        ensure => link,
        target => "/opt/${tomcat::params::untared_name}",
        require => Class["tomcat::install"], }

   file {"/etc/init.d/tomcat":
        source => "puppet:///modules/tomcat/tomcat",
        owner => root, group => root, mode => 0755,
        ensure => present, }

    file {"/etc/profile.d/tomcat.sh":
        source => "puppet:///modules/tomcat/tomcat.sh",
        owner => "root", group => "root", mode => "0755",
        ensure => present,
        require => Class["tomcat::install"], }

   file {"/opt/tomcat/conf/tomcat-users.xml":
        content =>template("tomcat/tomcat-users.xml.erb"), 
        owner => root, group => root, mode => 0600,
        ensure => present,
        require => File["/opt/tomcat"],
        notify => Service["tomcat"], }

   file {"/opt/tomcat/lib/c3p0-0.9.1.2.jar":
       source => "puppet:///modules/tomcat/lib/c3p0-0.9.1.2.jar",
       owner => "root", group => "root", mode => "0644",
       ensure => present,
       require => Class["tomcat::install"], }

   file {"/opt/tomcat/lib/mysql-connector-java-5.1.12-bin.jar":
       source => "puppet:///modules/tomcat/lib/mysql-connector-java-5.1.12-bin.jar",
       owner => "root", group => "root", mode => "0644",
       ensure => present,
       require => Class["tomcat::install"], }

   file {"/opt/tomcat/lib/primrose.jar":
       source => "puppet:///modules/tomcat/lib/primrose.jar",
       owner => "root", group => "root", mode => "0644",
       ensure => present,
       require => Class["tomcat::install"], }

   file { "/usr/local/etc/GeoIPCity.dat":
    source => "puppet:///modules/maxmind/GeoLiteCity.dat",
    owner => "root", group => "root", mode => "0755", }

   #file {"/opt/tomcat/conf/server.xml":
   #     content =>template("tomcat/server.xml.erb"), 
   #     owner => root, group => root, mode => 0755,
   #     ensure => present,
   #     require => File["/opt/tomcat"], }

}#end of class tomcat::config
