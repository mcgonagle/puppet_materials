$username="elvis"
#$username="root"

$home = $username ? {
  "root"  => "/root",
  default => "/home/${username}",
} # $home

File {
  owner => "${username}",
  group => "${username}",
  mode  => 600,
} # File

file {
  "${home}":
    ensure  => directory;
  "${home}/.ssh":
    ensure  => directory;
  "${home}/.vimrc":
    mode    => 644,
    source  => "/etc/puppet/files/vimrc";
  "${home}/.vim":
    ensure  => directory,
    recurse => true,
    source  => "/etc/puppet/files/vim";
} # file

# solving with if/else
if $username == "root" {
  file { "${home}/.ssh/authorized_keys":
    ensure => absent,
  } # file
} else {
  file { "${home}/.ssh/authorized_keys":
    source => "/etc/puppet/files/${username}-authorized_keys";
  } # file
} # fi

# solving with case
#case $username {
#  root    : {
#    file { "${home}/.ssh/authorized_keys":
#      ensure => absent,
#    } # file
#  } # root
#  default : {
#    file { "${home}/.ssh/authorized_keys":
#      source => "/etc/puppet/files/${username}-authorized_keys";
#    } # file
#  } # root
#} # case
