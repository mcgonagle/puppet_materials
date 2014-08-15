# Class: jenkins
#
# Installs and manages jenkins.
# Include it to install and run jenkins with default settings
#
# Usage:
# include 

##import the defines and classes subdirectories
#import "defines/*.pp"
#import "classes/*.pp"

class jenkins {
 notice("inside $name")
 yumrepo{"jenkins":
    name => "jenkins",
    baseurl => "http://${servername}:80/cobbler/repo_mirror/jenkins",
    enabled => "1", 
    priority => "99",
    gpgcheck => "0", 
    metadata_expire => "1", }  

 package{"jenkins": 
    ensure => latest,
    require => Yumrepo["jenkins"], }
 
 file{"/etc/sysconfig/jenkins":
    source => "puppet:///modules/jenkins/jenkins",
    owner => "root", group => "root", mode => "0755", 
    require => Package["jenkins"], }

  nagmon::service {"jenkins":
    ensure => running,
    enable => true, 
    pid_file => "/var/run/jenkins.pid",
    init_script => "/etc/init.d/jenkins",
    warn => "1:",
    critical => "1:",
    nrpe_parameter => "-a nrpe",  
    require => Package["jenkins"],
    subscribe => File["/etc/sysconfig/jenkins"], }
}
