# Class: nfs::export::mh_creative
#
# Manages nfs::export::mh_creative share
# Include it to install and run nfs with default settings
#
# Usage:
# include nfs::export::mh_creative


class nfs::export::mh_creative inherits nfs {

 nfs::nfs_export { "weblogs":
    	export_dir=>"/var/www/html/mh",
    	export_to=>"*.manhunt.net",
    	squash_uid=>"2001",
    	squash_gid=>"2001", }


}#end of class nfs
