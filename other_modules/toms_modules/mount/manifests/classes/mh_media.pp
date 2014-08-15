class mount::mh::media inherits mount {
 $nfs_media_server = extlookup("nfs_media_server")

 file {"/v4_media":
 	ensure => directory, }

 mount { "/v4_media":
	atboot => true,
	ensure => mounted,
	fstype => nfs,
	device => "${nfs_media_server}:/ifs/data/media/images",
	options => "nfsvers=3,tcp,rsize=32768,wsize=32768,soft,intr,noatime",
	require => File["/v4_media"], }

 file {"/v4_media_staging":
	ensure => directory, }

 mount { "/v4_media_staging":
	atboot => true,
	ensure => mounted,
	fstype => nfs,
	device => "${nfs_media_server}:/ifs/data/staging_media/images",
	options => "nfsvers=3,tcp,rsize=32768,wsize=32768,soft,intr,noatime", 
	require => File["/v4_media_staging"], }

 file {"/var/www/html/xxxmas":
	ensure => directory,}

 mount { "/var/www/html/xxxmas":
	atboot => true,
	ensure => mounted,
	fstype => nfs,
	device => "${nfs_media_server}:/ifs/data/xxxmedia",
	options => "nfsvers=3,tcp,rsize=32768,wsize=32768,soft,intr,noatime", 
	require => File["/var/www/html/xxxmas"], }


}#end of class mount::mh::media
