class rsync {
 include xinetd
 package{"rsync": ensure => latest }

}#end of rsync
