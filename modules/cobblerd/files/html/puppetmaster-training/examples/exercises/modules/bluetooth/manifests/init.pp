# declaring the bluetooth class
class bluetooth($disable="no") {

  case $disable {
    "yes": {
      $packageEnsure = absent
      Service["hidd"] -> Package["bluez-utils"] -> Package["bluez-libs"]
    } # yes
    default: {
      $packageEnsure = installed
      Package["bluez-libs"] -> Package["bluez-utils"] -> Service["hidd"]
    } # default
  } # case $disable

  Package {
    ensure => $packageEnsure,
  } # Package

  package {
    "bluez-utils":;
    "bluez-libs":;
  } # package

  service { "hidd":
    ensure    => $disable ? {
      "yes"   => stopped,
      default => running,
    }, # ensure
    enable    => $disable ? {
      "yes"   => false,
      default => true,
    }, # enable
    hasstatus  => true,
    hasrestart => true,
    status     => "source /etc/init.d/functions && status hidd",
  } # service
} # class bluetooth
