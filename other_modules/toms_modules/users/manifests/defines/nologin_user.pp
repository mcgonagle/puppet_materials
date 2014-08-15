define users::nologin_user_def ($uid, $gid, 
  $shell = "/sbin/nologin", $comment = "") {
    $user = $name

  user {"${user}": 
    ensure => present, 
    uid => "${uid}",
    gid => "${gid}",
    shell => "/sbin/nologin",
    comment => "${comment}",
    require => Group ["${user}"], }
  
  group {"${user}": ensure => present, gid => "${gid}", allowdupe => false, }
  
}#end of user::purge_users_def define
