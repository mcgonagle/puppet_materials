# Class: subversion
#
# Installs and manages subversion.
# Include it to install and run subversion with default settings
#
# Usage:
# include 

##import the defines and classes subdirectories
#import "defines/*.pp"
#import "classes/*.pp"

class subversion {
 yumrepo{"subversion":
    name => "subversion",
    baseurl => "http://${servername}:80/cobbler/repo_mirror/subversion",
    enabled => "1", 
    priority => "99",
    gpgcheck => "0", 
    metadata_expire => "1", }    

  package { "subversion": 
    ensure => latest,
    require => Yumrepo["subversion"], }

}#end of subversion

