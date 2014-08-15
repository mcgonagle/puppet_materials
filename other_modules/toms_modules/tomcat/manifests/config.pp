class tomcat::config {
   require sun-java

   file{"/opt/tomcat":
        ensure => link,
        target => "$tomcat::params::untarred_name",
        require => Class["tomcat::install"], }

   file {"/etc/init.d/tomcat":
        source => "puppet:///modules/tomcat/tomcat",
        owner => root, group => root, mode => 0755,
        ensure => present, }

   file {"/opt/tomcat/conf/tomcat-users.xml":
        content =>template("tomcat/tomcat-users.xml.erb"), 
        owner => root, group => root, mode => 0755,
        ensure => present,
        require => File["/opt/tomcat"],
        notify => Service["tomcat"], }

    file {"/etc/profile.d/tomcat.sh":
        source => "puppet:///modules/tomcat/tomcat.sh",
        owner => "root", group => "root", mode => "0755",
        ensure => present,
        require => Class["tomcat::install"], }

   #file {"/opt/tomcat/conf/server.xml":
   #     content =>template("tomcat/server.xml.erb"), 
   #     owner => root, group => root, mode => 0755,
   #     ensure => present,
   #     require => File["/opt/tomcat"], }

}#end of class tomcat::config
