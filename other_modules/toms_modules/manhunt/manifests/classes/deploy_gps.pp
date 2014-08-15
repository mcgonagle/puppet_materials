class manhunt::deploy_gps inherits manhunt {
 include appyml
 include appyml::gps

 $gps_version = extlookup("${zone}::gps_version")

 common::unarchive::tar-gz{"${gps_version}":
        file => "${gps_version}.tgz",
        untared_file => "${gps_version}",
        module_url => "puppet:///modules/manhunt/deploy",
        destination => "/usr/local/src",
        before => File["/usr/local/src/manhunt"], }

 file {"/usr/local/src/manhunt_gps":
        ensure => "link",
        target => "/usr/local/src/${gps_version}", }

 file {"/usr/local/src/${gps_version}/config/config.php":
        source => "puppet:///modules/manhunt/config.php",
        owner => "build", group => "build-devel", mode => "0755", 
        require => Common::Unarchive::Tar-gz["${gps_version}"], }

 file {"/usr/local/src/${gps_version}/cache":
        owner => "build", group => "build-devel", mode => "0777", 
        require => Common::Unarchive::Tar-gz["${gps_version}"], }

 file {"/usr/local/src/${gps_version}/cache/frontend":
        owner => "build", group => "build-devel", mode => "0777", 
        require => [Common::Unarchive::Tar-gz["${gps_version}"], 
                    File["/usr/local/src/${gps_version}/cache"]], }

 file {"/usr/local/src/${gps_version}/cache/frontend/dev":
        owner => "build", group => "build-devel", mode => "0777", 
        require => [Common::Unarchive::Tar-gz["${gps_version}"], 
                    File["/usr/local/src/${gps_version}/cache"],
                    File["/usr/local/src/${gps_version}/cache/frontend"]], }
 
 file {"/usr/local/src/${gps_version}/cache/frontend/prod":
        owner => "build", group => "build-devel", mode => "0777", 
        require => [Common::Unarchive::Tar-gz["${gps_version}"], 
                    File["/usr/local/src/${gps_version}/cache"],
                    File["/usr/local/src/${gps_version}/cache/frontend"]], }

 file {"/usr/local/src/${gps_version}/web/uploads":
        owner => "build", group => "build-devel", mode => "0777", 
        require => Common::Unarchive::Tar-gz["${gps_version}"], }

 file {"/usr/local/src/${gps_version}/web/uploads/assets":
        owner => "build", group => "build-devel", mode => "0777", 
        require => [Common::Unarchive::Tar-gz["${gps_version}"], 
                    File["/usr/local/src/${gps_version}/web/uploads"]], }

 file {"/usr/local/src/${gps_version}/web/uploads/thumbnails":
        owner => "build", group => "build-devel", mode => "0777", 
        require => [Common::Unarchive::Tar-gz["${gps_version}"], 
                    File["/usr/local/src/${gps_version}/web/uploads"]], }
 
 
}#end of manhunt::deploy::gps
