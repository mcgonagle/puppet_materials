define common::unarchive::unzip($file, $unzipped_file, $module_url, $destination) {

  file {"${destination}/${file}":
   source => "${module_url}/${file}",
   ensure => present,
   require => Package["unzip"], 
  }

  exec { "/usr/bin/unzip -d ${destination} ${destination}/${file}":
    creates => "${destination}/${unzipped_file}",
    subscribe => File["${destination}/${file}"],
  }
}
