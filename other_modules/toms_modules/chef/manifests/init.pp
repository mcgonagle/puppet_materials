class chef {
 #http://wiki.opscode.com/display/chef/Quick+Start
 package{"chef": ensure => present, provider => gem, }
 package{"git": ensure => present, provider => gem, }
 exec {"/usr/bin/git clone git://github.com/opscode/chef-repo.git":
	cwd => "/etc/chef",
	path => "/usr/bin/git", 
        creates => "/etc/chef/chef-repo",
	require => [ Package["git"], Package["chef"], } 

 file {"/etc/chef/chef-repo/.chef":
	ensure => directory,
	require => Exec["/usr/bin/git clone git://github.com/opscode/chef-repo.git"], }

 file {"/etc/chef/chef-repo/.chef/knife.rb":
	source => "puppet:///modules/chef/knife.rb",
	owner => "root", group => "root", mode => "0644",
	require => File["/etc/chef/chef-repo/.chef"], }

 file {"/etc/chef/chef-repo/.chef/lr-validator.pem":
	source => "puppet:///modules/chef/knife.rb",
	owner => "root", group => "root", mode => "0644",
	require => File["/etc/chef/chef-repo/.chef"], }

 file {"/etc/chef/chef-repo/.chef/mcgonagletom.pem":
	source => "puppet:///modules/chef/knife.rb",
	owner => "root", group => "root", mode => "0644",
	require => File["/etc/chef/chef-repo/.chef"], }

}
