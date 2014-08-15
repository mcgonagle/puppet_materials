import "classes/*.pp"
class product {
  $kits_dir = extlookup("kits_dir")
  $firstrun = extlookup("firstrun")
  
  file { "/etc/profile.d/${orgname}.sh":
        source => [ "puppet:///modules/product/${product}/${orgname}.sh",
		    "puppet:///modules/product/mh/manhunt.sh"],
        owner => "root", group => "root", mode => "0755", }

  file {"/etc/${orgname}":
        ensure => directory,
        owner => "root", group => "root", mode => "0755",
        require => File["/etc/profile.d/${orgname}.sh"], }

  file {"/etc/${orgname}/source.sh":
        source => [ "puppet:///modules/product/${product}/source.sh.${orgname}",
                    "puppet:///modules/product/mh/source.sh"],
        owner => "root", group => "root", mode => "0755",
        require => File["/etc/${orgname}"], }
  
  file { "/usr/local/manhunt":
    	ensure => directory,
    	owner => "root", group => "root", mode => "0755", }

  file { "/usr/local/bigbearden":
    	ensure => link,
    	target => "/usr/local/manhunt", }

  file { "/usr/local/dlist":
    	ensure => link,
    	target => "/usr/local/manhunt", }

  file { "/usr/local/manhunt/bin":
    	ensure => directory,
    	owner => "root", group => "root", mode => "0755",
    	require => File["/usr/local/manhunt"], }

  file { "/usr/local/manhunt/etc":
    	ensure => directory,
    	owner => "root", group => "root", mode => "0755",
    	require => File["/usr/local/manhunt"], }

  file { "/usr/local/manhunt/cron":
    	ensure => directory,
    	owner => "root", group => "root", mode => "0755",
    	require => File["/usr/local/manhunt"], }

  file { "${kits_dir}":
    	ensure => directory,
    	owner => "root", group => "root", mode => "0755",
    	require => File["/usr/local/${orgname}"], }

  file { "${firstrun}":
    	ensure => directory,
    	owner => "root", group => "root", mode => "0755",
    	require => File["/usr/local/${orgname}"], }

}#end of class product
