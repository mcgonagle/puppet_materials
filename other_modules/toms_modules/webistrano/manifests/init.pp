class webistrano {
 include httpd
 #file{"/opt/webistrano":
	#source => "puppet:///modules/webistrano/webistrano",
	#owner => "apache", group => "apache", mode => "0755", 
	#recurse => true,
	#replace => false, }

 file{"/etc/httpd/conf.d/webistrano.conf":
	source => "puppet:///modules/webistrano/webistrano.conf",
	owner => "apache", group => "apache", mode => "0644", }
	#notify => Service["httpd"], }

 file{"/opt/webistrano/config/database.yml":
	source => "puppet:///modules/webistrano/database.yml",
	owner => "apache", group => "apache", mode => "0755", }
	#notify => Service["httpd"], }

  #gem sources -a http://rubygems.org/
  #gem install rack -v=1.0.1

}
