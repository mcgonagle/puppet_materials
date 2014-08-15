# Class: ant
#
# Manages ant build server 
# Include it to install and run ant with default settings
#
# Usage:
# include ant

class ant {
   common::unarchive::tar-gz{"apache-ant-1.8.2":
      file => "apache-ant-1.8.2-bin.tar.gz",
      untared_file => "apache-ant-1.8.2",
      module_url => "puppet:///modules/ant/",
      destination => "/opt", }
   
   file {"/opt/ant":
      ensure => link,
      target => "/opt/apache-ant-1.8.2",
      require => Common::Unarchive::Tar-gz["apache-ant-1.8.2"], }

   file {"/etc/profile.d/ant.sh":
     source => "puppet:///modules/ant/ant.sh",
     owner => "root", group => "root", mode => 0755, 
     require => File["/opt/ant"], }
        
}#end of class ant

