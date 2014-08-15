class tomcat::install {

   common::unarchive::tar-gz{"$tomcat::params::tarball_name":
        file => "$tomcat::params::tarball_name",
        untared_file => "$tomcat::params::untared_name",
        module_url => "puppet:///modules/tomcat/",
        destination => "/opt", }

}#end of class tomcat::install
