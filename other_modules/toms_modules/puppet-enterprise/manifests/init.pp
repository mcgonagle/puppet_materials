class puppet-enterprise {
  yumrepo{"puppet-enterprise":
    name => "puppet-enterprise",
    baseurl => "http://${servername}:80/cobbler/repo_mirror/puppet-enterprise",
    enabled => "1", 
    priority => "99",
    gpgcheck => "0", 
    metadata_expire => "1", }  

}#end of class puppet-enterprise
