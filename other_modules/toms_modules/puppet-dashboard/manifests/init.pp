# Class: puppet-dashboard
#
# Manages Puppet-Dashboard software 
# Include it to install and run puppet-dashboard with default settings
#
# Usage:
# include puppet-dashboard

class puppet-dashboard {

 require mysql::server

 yumrepo{"puppetlabs":
   name => "Puppet Labs Packages",
   baseurl => "http://yum.puppetlabs.com/base/",
   enabled => 1,
   gpgcheck => 1,
   gpgkey => "http://yum.puppetlabs.com/RPM-GPG-KEY-puppetlabs", }

 package{"puppet-dashboard": 
    ensure => latest,
	  require => Yumrepo["puppetlabs"], }

 file {"/usr/lib/ruby/site_ruby/1.8/puppet/reports/puppet_dashboard.rb":
	  source => "puppet:///modules/puppet-dashboard/puppet_dashboard.rb",
  	owner => "root", group => "root", mode => "0755",
  	require => Package["puppet-dashboard"], }

 file {"/usr/share/puppet-dashboard/log/production.log":
  	owner => "root", group => "root", mode => "0666",
  	require => Package["puppet-dashboard"], }

 nagmon::service{"puppet-dashboard":
 	  enable => true,
 	  ensure => running,
    pid_file => "/var/run/puppet-dashboard.pid",
    init_script => "/etc/init.d/puppet-dashboard",
    warn => "3:3",
    critical => "3:3",
    nrpe_parameter => "-a puppet-dashboard", 
	  require => [ Package["puppet-dashboard"], 
		      File["/usr/share/puppet-dashboard/log/production.log"]], }

}
