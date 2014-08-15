define mysql::grant (
    $mysql_db,
    $mysql_user,
    $mysql_password,
    $mysql_privileges = "ALL",
    $mysql_host = "localhost",
    $mysql_grant_filepath = "/root"
    ) {
    notice("Creating ${name} database")

    file {
        "mysqlgrant-$mysql_user-$mysql_db.sql":
        mode => 600, owner => root, group => root,
        ensure => present,
        path => "$mysql_grant_filepath/mysqlgrant-$mysql_user-$mysql_db.sql",
        content => template("mysql/grant.erb"),
        notify => Exec["mysqlgrant-$mysql_user-$mysql_db"],
    }

    exec {
        "mysqlgrant-$mysql_user-$mysql_db":
            command => "/usr/bin/mysql -u root < $mysql_grant_filepath/mysqlgrant-$mysql_user-$mysql_db.sql",
            require => Service["mysql"],
            unless  => "/usr/bin/mysql --user=$mysql_user --password=$mysql_password $mysql_db",
    }

}

