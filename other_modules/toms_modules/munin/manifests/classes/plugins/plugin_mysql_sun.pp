class munin::plugin::mysql::sun inherits munin::plugin::mysql {
  File ["/etc/munin/plugin-conf.d/mysql"] { content => inline_template("[mysql_*]
env.mysqlconnection DBI:mysql:mysql;host=localhost;port=3306
env.mysqluser root
env.mysqlpassword Pdn1uL+p") }
}#end of class munin::plugin::mysql
