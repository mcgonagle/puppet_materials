define common::rpm::install::no::yum($file, $module_url, $destination) {
  file {"${destination}/${file}":
   source => "${module_url}/${file}",
   ensure => present,
   notify => Exec["rpm-install-jprofiler"], }

 #package {"$file": 
    #provider => rpm, 
    #source => "${destination}/${file}",
    #ensure => present }

 exec {"rpm -Uvh ${destination}/${file}":
        path => ["bin"],
	onlyif => "! rpm -qa|grep jprofiler",
	refreshonly => true }

}
