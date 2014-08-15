class product::mh::deploy_manhunt inherits product::mh {
 include appyml
 include appyml::mh

 $mh_version = extlookup("${zone}::mh_version")
 $creative_sync_server = extlookup("creative_sync_server")
 $rsync_command = "/usr/bin/rsync -a --delete-before --force --ignore-errors"

 common::unarchive::tar-gz{"${mh_version}":
        file => "${mh_version}.tgz",
        untared_file => "${mh_version}",
        module_url => "puppet:///modules/manhunt/deploy",
        destination => "/usr/local/src",
        before => File["/usr/local/src/manhunt"], }
 
 file { "/var/www/html/mh":
        ensure  => directory,
        owner => "media", group => "media", mode => "2775", 
        require => Common::Unarchive::Tar-gz["${mh_version}"], }

 cron { "rsync creative content":
    	  command => "${rsync_command} ${creative_sync_server}:/mnt/manhunt/other/creative/* /var/www/html/mh",
    	  user => care,
    	  hour => "*/1",
	      require => File["/var/www/html/mh"], }#end of cron sync

 exec {"su - care ${rsync_command} ${creative_sync_server}:/mnt/manhunt/other/creative/* /var/www/html/mh":
	      path => "/bin:/usr/bin:/sbin:/usr/sbin",
	      creates => "/var/www/html/mh/AA",
	      require => File["/var/www/html/mh"], }

 file {"/usr/local/src/manhunt":
        ensure => "link",
        target => "/usr/local/src/${mh_version}", 
        require => Common::Unarchive::Tar-gz["${mh_version}"], }

 file {"/usr/local/src/${mh_version}/config/config.php":
        source => "puppet:///modules/manhunt/config.php",
        owner => "build", group => "build-devel", mode => "0755", 
        require => Common::Unarchive::Tar-gz["${mh_version}"], }
 
 file {"/usr/local/src/${mh_version}/cache":
        owner => "build", group => "build-devel", mode => "0777", 
        require => Common::Unarchive::Tar-gz["${mh_version}"], }

 file {"/usr/local/src/${mh_version}/cache/frontend":
        owner => "build", group => "build-devel", mode => "0777", 
        require => [Common::Unarchive::Tar-gz["${mh_version}"], 
                    File["/usr/local/src/${mh_version}/cache"]], }

 file {"/usr/local/src/${mh_version}/cache/frontend/dev":
        owner => "build", group => "build-devel", mode => "0777", 
        require => [Common::Unarchive::Tar-gz["${mh_version}"], 
                    File["/usr/local/src/${mh_version}/cache"],
                    File["/usr/local/src/${mh_version}/cache/frontend"]], }
 
 file {"/usr/local/src/${mh_version}/cache/frontend/prod":
        owner => "build", group => "build-devel", mode => "0777", 
        require => [Common::Unarchive::Tar-gz["${mh_version}"], 
                    File["/usr/local/src/${mh_version}/cache"],
                    File["/usr/local/src/${mh_version}/cache/frontend"]], }

 file {"/usr/local/src/${mh_version}/web/uploads":
        owner => "build", group => "build-devel", mode => "0777", 
        require => Common::Unarchive::Tar-gz["${mh_version}"], }

 file {"/usr/local/src/${mh_version}/web/uploads/assets":
        owner => "build", group => "build-devel", mode => "0777", 
        require => [Common::Unarchive::Tar-gz["${mh_version}"], 
                    File["/usr/local/src/${mh_version}/web/uploads"]], }

 file {"/usr/local/src/${mh_version}/web/uploads/thumbnails":
        owner => "build", group => "build-devel", mode => "0777", 
        require => [Common::Unarchive::Tar-gz["${mh_version}"], 
                    File["/usr/local/src/${mh_version}/web/uploads"]], }
 
 
}#end of product::mh::deploy_manhunt
