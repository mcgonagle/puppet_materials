class sudo {

  $toBeChecked="/etc/sudoers.check"

  file {
    "${toBeChecked}":
      source => "puppet:///modules/sudo/sudoers";
    "/etc/sudoers":
      source => "puppet:///modules/sudo/sudoers",
      require => Exec["visudo -cf ${toBeChecked}"];
  } # file

  exec { "visudo -cf ${toBeChecked}":
    path     => "/usr/sbin/:/usr/bin",
    unless   => "diff ${toBeChecked} /etc/sudoers",
    require  => File["${toBeChecked}"],
  } # exec
} # class sudo
