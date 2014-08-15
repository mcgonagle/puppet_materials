class role::spsdb inherits role {
 include mysql::server::sun
 include mysql::server::sun::my_cnf
 include sphinx
 include multi_mysql::mysql_A
 include multi_mysql::mysql_B
}#end of role spsdb
