class mac::macports {
 $KITS_DIR = extlookup("kits_dir")
 file{"${KITS_DIR}/MacPorts-1.9.2-10.6-SnowLeopard.dmg":
  source => "puppet:///modules/mac/packages/MacPorts-1.9.2-10.6-SnowLeopard.dmg",
  owner => "root", group => "wheel", mode => "0777",
  require => File["${KITS_DIR}"], }
  
 package{"MacPorts-1.9.2-10.6-SnowLeopard.dmg": 
  ensure => installed, 
  provider => pkgdmg, 
  source => "${KITS_DIR}/MacPorts-1.9.2-10.6-SnowLeopard.dmg", 
  require => File["${KITS_DIR}/MacPorts-1.9.2-10.6-SnowLeopard.dmg"], }
}#end of mac::macports class
