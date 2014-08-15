define common::unarchive::tar-gz (
  $file,
  $untared_file,
  $module_url,
  $destination,
  $user  = "root",
  $group = "root"
) {

  #notice("${destination}/${file}")

  file {"${destination}/${file}":
    source => "${module_url}/${file}",
    ensure => present,
  }

  #notice("${destination}/${untared_file}")
  exec { "/bin/tar -xzf ${destination}/${file} -C ${destination} && /bin/chown -R \"${user}:${group}\" ${destination}/${untared_file}":
    ##command => "cd ${destination};/bin/tar -xzf ${file} -C ${destination}",
    ##command => "/bin/tar -xzf ${destination}/${file} -C ${destination}",
    creates   => "${destination}/${untared_file}",
    subscribe => File["${destination}/${file}"],
    #onlyif => "/bin/false",
  }
}
