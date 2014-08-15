define users::manage_user(
  $uid,
  $password, 
  $gid              = "", 
  $manage_homedir   = "false",
  $other_groups     = "",
  $comment	    = "",
  $ssh_dss_auth_key = "",
  $ssh_rsa_auth_key = "",
  $shell            = "/bin/bash",
  $ensure           = "present" ) {


  if($ensure == 'absent' and $name == 'root'){
    fail('will not delete root user')
  }

  if($gid) {
    $group = $gid
  } else {
    $group = $name
  }

  $home = $name ? {
    'root'  => "/root",
    default => "/home/${name}",
  }

  group { "${name}":
    ensure => $ensure,
    #ran into some logic problems with this
    #changing gid to uid
    #gid   => $group,
    gid    => $uid,
    before => User["$name"],
  }

  user { "${name}":
    ensure     => $ensure,
    uid        => $uid,
    gid        => $group,
    groups     => $other_groups,
    home       => $home,
    managehome => $manage_homedir,
    password   => $password,
    comment    => $comment,
    require    => [ Class["users::groups"], Class["users::purge_users"] ],

  }

if $manage_homedir == "true" {
 if $home == "/root" { } 
 else {
  file { "${home}":
   ensure   => directory,
   recurse  => false,
   replace  => false,
   ignore   => "*",
   checksum => none,
   owner    => "$uid", group => "$gid", mode => "0700",
   source   => [ "puppet:///modules/users/homedir_files/${name}",
	               "puppet:///modules/users/BLANK"
               ],
  }#end of file declaration

 }#end of else
}#end of manage_homedir == true

 if $ssh_dss_auth_key == "" {}
 else {
  ssh_authorized_key { "${name}-dss":
   ensure => present,
   name   => "${name}-dss@cobbler",
   type   => "ssh-dss",
   key    => "$ssh_dss_auth_key",
   user   => "${name}",
  }#end of ssh_authorized_key
 }#end of ssh_dss_auth_key else

 if $ssh_rsa_auth_key == "" {}
 else {
  ssh_authorized_key { "${name}-rsa": 
   ensure => present,
   name   => "${name}-rsa@cobbler",
   type   => "ssh-rsa",
   key    => "$ssh_rsa_auth_key",
   user   => "${name}",
  }#end of ssh_authorized_key
 }#end of ssh_rsa_auth_key else

}#end of define
