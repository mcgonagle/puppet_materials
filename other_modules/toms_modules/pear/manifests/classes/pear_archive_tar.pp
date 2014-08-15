# Class: pear::archive_tar
#
# Installs Pear for PHP module
#
# Usage:
# include pear::archive_tar

class pear::archive_tar inherits pear {
  package { "Archive_Tar":
	  name     => "Archive_Tar",
	  provider => "pear",
	  ensure   => latest,
    require => [ Exec["pear channel-update pear.php.net && touch /var/tmp/pear_channel_update"],
                 Exec["pear upgrade -f pear && touch /var/tmp/pear_upgrade_pear"] ], }

}#end of class pear::archive_tar
