# Class: php::pear::xml_rpc2
#
# Installs Pear for PHP module
#
# Usage:
# include php::pear::xml_rpc2

class pear::xml_rpc2 inherits pear {
  package { "xml_rpc2":
	  name     => "XML_RPC2",
	  provider => "pear",
	  ensure   => latest, 
    require => [ Exec["pear channel-update pear.php.net && touch /var/tmp/pear_channel_update"],
                 Exec["pear upgrade -f pear && touch /var/tmp/pear_upgrade_pear"] ], }
}#end of class pear::xml_rpc2
