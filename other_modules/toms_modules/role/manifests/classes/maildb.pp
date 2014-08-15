class role::maildb inherits role {
  include mysql::server::sun
  include mysql::server::sun::my_cnf
}#end of role maildb
