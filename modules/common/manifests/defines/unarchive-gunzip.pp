define common::unarchive::gunzip($file, $unzipped_file, $module_url, $destination) {

  file {"${destination}/${file}":
   source => "${module_url}/${file}",
   ensure => present,
   require => Package["unzip"], 
  }

  exec { "/usr/bin/gunzip ${destination}/${file}":
    cwd => "${destination}",
    creates => "${destination}/${unzipped_file}",
    subscribe => File["${destination}/${file}"],
  }
}
