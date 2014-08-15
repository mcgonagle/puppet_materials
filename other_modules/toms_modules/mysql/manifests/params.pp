class mysql::params {
#basic settings
$client_packagename = $role ? {
    default => "MySQL-client-community",
}                  

$server_packagename = $role ? {
    default => "MySQL-server-community",
}

$servicename = $role ? {
    default => "mysql",
}

$my_cnf_path = $role ? {
    default => "/etc/my.cnf",
}     

$thread_concurrency = "0"

}#end of mysql::params class
