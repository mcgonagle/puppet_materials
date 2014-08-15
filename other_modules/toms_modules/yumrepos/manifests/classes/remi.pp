# Class: yumrepos::remi
#
# Installs and manages the local remi yum repository
# Usage:
# include  yumrepos::remi


class yumrepos::remi inherits yum_repos {

class enabled {
 yumrepo{"remi":
        name => "remi",
        baseurl => "http://${servername}:80/cobbler/repo_mirror/remi",
        enabled => "1",
        priority => "10",
        gpgcheck => "0",
        metadata_expire => "1", }
}

class disabled {
 yumrepo{"remi":
        name => "remi",
        baseurl => "http://${servername}:80/cobbler/repo_mirror/remi",
        enabled => "0",
        priority => "10",
        gpgcheck => "0",
        metadata_expire => "1", }
}

}#end of class yumrepos::remi
