define common::ldconfig( $file) {
  file {"/etc/ld.so.conf.d/${file}":
   content => "${name}}",
   ensure => present, 
   notify => Exec["/sbin/ldconfig"], }


 exec {"/sbin/ldconfig":
        path => ["/sbin"],
	refreshonly => true, }

}
