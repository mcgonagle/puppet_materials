class usermanagement {
  define manage_user($gid="", $ensure=present) {
    if ($ensure == "absent" and $name == "root") {
      fail("will not delete root user")
    } # fi

   if $gid {
      $group = $gid
    } else {
      $group = $name
    } # fi

    $home = $name ? {
      "root"  => "/root",
      default => "/home/${name}",
    } # $home

    user { "${name}":
      ensure => $ensure,
      gid    => $group,
      home   => $home,
    } # user

    case $ensure {
      absent: {
        # you may not want to have such a brutal user management policy :)
        file { "${home}":
          ensure  => $ensure,
          force   => true,
          recurse => true,
        } # file
      } # absent:

      present: {
        if ! defined ( Group[$group] ) {
          group { "${group}":
            ensure  => $ensure,
            #before => User[$name],
          } # group
        } # fi
        file { "${home}":
          owner  => $name,
          group  => $group,
          mode   => "700",
          ensure => directory,
        } # file
      } # present:
    } # case $ensure
  } # define manage_user
} # class usermanagement
