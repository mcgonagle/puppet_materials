class role::trackdb inherits role {
  include mysql::server::sun
  include mysql::server::sun::my_cnf
}#end of role trackdb 
