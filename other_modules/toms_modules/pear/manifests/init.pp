# Class: pear
#
# Installs Pear for PHP module
#
# Usage:
# include pear
import "classes/*.pp"
class pear  {
    require php
    package { php-pear: name => "php-pear", ensure => present,
	      before => Exec['pear_channel_update'],
    }

   exec { 'pear channel-update pear.php.net && touch /var/tmp/pear_channel_update':
      path => "/bin:/usr/bin:/usr/local/bin:/usr/sbin",
      creates => "/var/tmp/pear_channel_update",
      require => Package[php-pear],
      alias => 'pear_channel_update',
    }  

   exec { 'pear upgrade -f pear && touch /var/tmp/pear_upgrade_pear':
      path => "/bin:/usr/bin:/usr/local/bin:/usr/sbin",
      creates => "/var/tmp/pear_upgrade_pear",
      require => Exec['pear channel-update pear.php.net && touch /var/tmp/pear_channel_update'],
      alias => 'pear_upgrade_pear',
    }  

   exec { 'pear upgrade-all && touch /var/tmp/pear_upgrade_all':
      path => "/bin:/usr/bin:/usr/local/bin:/usr/sbin",
      creates => "/var/tmp/pear_upgrade_all",
      require => Exec['pear upgrade -f pear && touch /var/tmp/pear_upgrade_pear'],
      alias => 'pear_upgrade_all'
    }  
}#end of pear class
