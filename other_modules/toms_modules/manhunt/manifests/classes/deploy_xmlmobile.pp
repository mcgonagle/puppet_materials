class manhunt::deploy_xmlmobile inherits manhunt {
 include appyml
 include appyml::xml

 $xmlmobile_version = extlookup("${zone}::xmlmobile_version")
 notice ("xmlmobile version is $xmlmobile_version")

 common::unarchive::tar-gz{"${xmlmobile_version}":
        file => "${xmlmobile_version}.tgz",
        untared_file => "${xmlmobile_version}",
        module_url => "puppet:///modules/manhunt/deploy",
        destination => "/usr/local/src",
        before => File["/usr/local/src/manhunt"], }

 file {"/usr/local/src/manhunt_xmlmobile":
        ensure => "link",
        target => "/usr/local/src/${xmlmobile_version}", }

 file {"/usr/local/src/${xmlmobile_version}/config/config.php":
        source => "puppet:///modules/manhunt/config.php",
        owner => "build", group => "build-devel", mode => "0755", 
        require => Common::Unarchive::Tar-gz["${xmlmobile_version}"], }

 file {"/usr/local/src/${xmlmobile_version}/cache":
        owner => "build", group => "build-devel", mode => "0777", 
        require => Common::Unarchive::Tar-gz["${xmlmobile_version}"], }

 file {"/usr/local/src/${xmlmobile_version}/cache/frontend":
        owner => "build", group => "build-devel", mode => "0777", 
        require => [Common::Unarchive::Tar-gz["${xmlmobile_version}"], 
                    File["/usr/local/src/${xmlmobile_version}/cache"]], }

 file {"/usr/local/src/${xmlmobile_version}/cache/frontend/dev":
        owner => "build", group => "build-devel", mode => "0777", 
        require => [Common::Unarchive::Tar-gz["${xmlmobile_version}"], 
                    File["/usr/local/src/${xmlmobile_version}/cache"],
                    File["/usr/local/src/${xmlmobile_version}/cache/frontend"]], }
 
 file {"/usr/local/src/${xmlmobile_version}/cache/frontend/prod":
        owner => "build", group => "build-devel", mode => "0777", 
        require => [Common::Unarchive::Tar-gz["${xmlmobile_version}"], 
                    File["/usr/local/src/${xmlmobile_version}/cache"],
                    File["/usr/local/src/${xmlmobile_version}/cache/frontend"]], }

 file {"/usr/local/src/${xmlmobile_version}/web/uploads":
        owner => "build", group => "build-devel", mode => "0777", 
        require => Common::Unarchive::Tar-gz["${xmlmobile_version}"], }

 file {"/usr/local/src/${xmlmobile_version}/web/uploads/assets":
        owner => "build", group => "build-devel", mode => "0777", 
        require => [Common::Unarchive::Tar-gz["${xmlmobile_version}"], 
                    File["/usr/local/src/${xmlmobile_version}/web/uploads"]], }

 file {"/usr/local/src/${xmlmobile_version}/web/uploads/thumbnails":
        owner => "build", group => "build-devel", mode => "0777", 
        require => [Common::Unarchive::Tar-gz["${xmlmobile_version}"], 
                    File["/usr/local/src/${xmlmobile_version}/web/uploads"]], }
 
 
}#end of manhunt::deploy::xml
