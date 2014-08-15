define common::unarchive::tar($source, $target) {
  exec {"$name unpack":
    command => "curl ${source} | tar -xf - -C ${target} && touch ${name}",
    creates => $name,
    require => Package[curl],
  }
}
