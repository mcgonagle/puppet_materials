import "classes/*.pp"
import "defines/*.pp"
class mac {
 include mac::macports
 #will probably move the kits def to the common class
 $KITS_DIR = "/var/lib/puppet/KITS"
 file{ "${KITS_DIR}":
  ensure => directory,
  owner => "root", group => "wheel", mode => "0755", }
}
