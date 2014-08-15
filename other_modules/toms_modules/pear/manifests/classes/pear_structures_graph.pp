# Class: php::pear::structures_graph
#
# Installs Pear for PHP module
#
# Usage:
# include php::pear::structures_graph

class pear::structures_graph inherits pear {
  package { "structures_graph":
	  name     => "Structures_Graph",
	  provider => "pear",
	  ensure   => latest,
    require => [ Exec["pear channel-update pear.php.net && touch /var/tmp/pear_channel_update"],
                 Exec["pear upgrade -f pear && touch /var/tmp/pear_upgrade_pear"] ], }
}#end of class pear::structures_graph
