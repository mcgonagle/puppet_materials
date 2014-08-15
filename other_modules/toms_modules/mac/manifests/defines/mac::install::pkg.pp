define mac::install::pkg() {

 $KITS_DIR = "/var/lib/puppet/KITS"

 file{"${KITS_DIR}/${name}":
  source => "puppet:///modules/mac/packages/${name}",
  owner => "root", group => "wheel", mode => "0777",
  require => File["${KITS_DIR}"], }
  
 package{"${name}": 
  ensure => installed, 
  provider => pkg, 
  source => "${KITS_DIR}/${name}", 
  require => File["${KITS_DIR}/${name}"], }

}#end of mac::install::pkg
