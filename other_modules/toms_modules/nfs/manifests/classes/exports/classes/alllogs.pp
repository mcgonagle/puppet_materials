# Class: nfs::export::alllogs
#
# Manages nfs::export::alllogs share
# Include it to install and run nfs with default settings
#
# Usage:
# include nfs::export::alllogs


class nfs::export::alllogs inherits nfs {

 nfs::nfs_export { "alllogs":
    	export_dir=>"/var/log",
    	export_to=>"logviewer*.manhunt.net",
    	squash_uid=>"2001",
    	squash_gid=>"2001", }

}#end of class nfs
