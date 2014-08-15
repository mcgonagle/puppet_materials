class users::purge_users inherits users {
  $users = [ "adm", "bin", "gopher", "news", "operator", "games", "uucp" ]
  
  users::purge_users_def { "${users}": alias => "purging_users", }
  
}#users::purge_user
