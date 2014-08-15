class product::mh::deploy_mobile inherits product::mh {
 include appyml
 include appyml::mo

 $mobile_version = extlookup("${zone}::mobile_version")

 common::unarchive::tar-gz{"${mobile_version}":
        file => "${mobile_version}.tgz",
        untared_file => "${mobile_version}",
        module_url => "puppet:///modules/manhunt/deploy",
        destination => "/usr/local/src",
        before => File["/usr/local/src/manhunt"], }

 file {"/usr/local/src/mobile":
        ensure => "link",
        target => "/usr/local/src/${mobile_version}", }

 file {"/usr/local/src/${mobile_version}/config/config.php":
        source => "puppet:///modules/manhunt/config.php",
        owner => "build", group => "build-devel", mode => "0755", 
        require => Common::Unarchive::Tar-gz["${mobile_version}"], }
 
 file {"/usr/local/src/${mobile_version}/cache":
        owner => "build", group => "build-devel", mode => "0777", 
        require => Common::Unarchive::Tar-gz["${mobile_version}"], }

 file {"/usr/local/src/${mobile_version}/cache/frontend":
        owner => "build", group => "build-devel", mode => "0777", 
        require => [Common::Unarchive::Tar-gz["${mobile_version}"], 
                    File["/usr/local/src/${mobile_version}/cache"]], }

 file {"/usr/local/src/${mobile_version}/cache/frontend/dev":
        owner => "build", group => "build-devel", mode => "0777", 
        require => [Common::Unarchive::Tar-gz["${mobile_version}"], 
                    File["/usr/local/src/${mobile_version}/cache"],
                    File["/usr/local/src/${mobile_version}/cache/frontend"]], }
 
 file {"/usr/local/src/${mobile_version}/cache/frontend/prod":
        owner => "build", group => "build-devel", mode => "0777", 
        require => [Common::Unarchive::Tar-gz["${mobile_version}"], 
                    File["/usr/local/src/${mobile_version}/cache"],
                    File["/usr/local/src/${mobile_version}/cache/frontend"]], }

 file {"/usr/local/src/${mobile_version}/web/uploads":
        owner => "build", group => "build-devel", mode => "0777", 
        require => Common::Unarchive::Tar-gz["${mobile_version}"], }

 file {"/usr/local/src/${mobile_version}/web/uploads/assets":
        owner => "build", group => "build-devel", mode => "0777", 
        require => [Common::Unarchive::Tar-gz["${mobile_version}"], 
                    File["/usr/local/src/${mobile_version}/web/uploads"]], }

 file {"/usr/local/src/${mobile_version}/web/uploads/thumbnails":
        owner => "build", group => "build-devel", mode => "0777", 
        require => [Common::Unarchive::Tar-gz["${mobile_version}"], 
                    File["/usr/local/src/${mobile_version}/web/uploads"]], }
 
 
}#end of manhuntdeploy_mobile
