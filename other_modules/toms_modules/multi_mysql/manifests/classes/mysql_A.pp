class multi_mysql::mysql_A inherits multi_mysql {

 $mysql_tar_ball = "mysql-enterprise-gpl-5.1.54-linux-x86_64-glibc23"
 $mysql_instance = "mysql_A"

 #@user{"mysql":
 #       ensure => present,
 #       uid => "27",
 #       gid => "mysql",
 #       home => "/var/lib/mysql",
 #       shell => "/bin/bash",
 #	tag => "mysql", }
 # User <| tag == "mysql" |> 


 common::unarchive::tar-gz{"${mysql_tar_ball}":
        file => "${mysql_tar_ball}.tar.gz",
        untared_file => "${mysql_tar_ball}",
        module_url => "puppet:///modules/multi_mysql/deploy",
        destination => "/var/lib/multi_mysql",
        require => File["/var/lib/multi_mysql"], }

 file {"/var/lib/multi_mysql/${mysql_instance}":
	ensure => link,
	target => "/var/lib/multi_mysql/${mysql_tar_ball}", 
	require => Common::Unarchive::Tar-gz["${mysql_tar_ball}"], }

 exec {"chown -R mysql:mysql /var/lib/multi_mysql/${mysql_tar_ball}":
        path => ["/bin", "/usr/bin", "/usr/sbin/" ],
	unless =>  "/bin/sh -c '[ $(/usr/bin/stat -c %U /var/lib/multi_mysql/) == mysql ]'",
	require => Common::Unarchive::Tar-gz["${mysql_tar_ball}"], }

 file {"/etc/init.d/${mysql_instance}":
	content => template("multi_mysql/${mysql_instance}"),
	owner => "mysql", group => "mysql", mode => "0755", 
	require => Common::Unarchive::Tar-gz["${mysql_tar_ball}"], }

}#end of class multi_mysql
