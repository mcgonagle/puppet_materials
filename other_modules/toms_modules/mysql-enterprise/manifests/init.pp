class mysql-enterprise {
  yumrepo{"mysql-enterprise":
    name => "mysql-enterprise",
    baseurl => "http://${servername}:80/cobbler/repo_mirror/mysql-enterprise",
    enabled => "1", 
    priority => "99",
    gpgcheck => "0", 
    metadata_expire => "1", }  

}#end of class mysql-enterprise
