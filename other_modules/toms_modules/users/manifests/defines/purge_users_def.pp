define users::purge_users_def () {
  $user = $name

  user {"${user}": ensure => absent, require => Group ["${user}"], }
  
  group {"${user}": ensure => absent, }
  
}#end of user::purge_users_def define
