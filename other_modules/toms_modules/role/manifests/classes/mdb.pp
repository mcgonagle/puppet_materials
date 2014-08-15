class role::mdb inherits role {
  include mysql::server::sun
  include mysql::server::sun::my_cnf
}#end of role mdb
