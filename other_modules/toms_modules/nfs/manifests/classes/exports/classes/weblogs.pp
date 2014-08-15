# Class: nfs::export::weblogs
#
# Manages nfs::export::weblogs share
# Include it to install and run nfs with default settings
#
# Usage:
# include nfs::export::weblogs


class nfs::export::weblogs inherits nfs {

 nfs::nfs_export { "weblogs":
    	export_dir=>"/var/log/httpd",
    	export_to=>"logviewer*.manhunt.net",
    	squash_uid=>"2001",
    	squash_gid=>"2001", }


}#end of class nfs
