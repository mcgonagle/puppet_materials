class bluetooth {
  package { 
    "bluez-libs":
      ensure => installed,
      before => Service["hidd"];
    "bluez-utils":
      ensure => installed,
      before => Service["hidd"];
  } # package

  service { "hidd":
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    status     => 'source /etc/init.d/functions && status hidd'
  } # service
} # class bluetooth
