class bluetooth::disable inherits bluetooth {

  Service["hidd"] {
    ensure => stopped,
    enable => false,
  } # Service

  Package["bluez-utils"] {
    ensure  => absent,
    before  => undef,
    require => Service["hidd"],
  } # Package

  Package["bluez-libs"] {
    ensure  => absent,
    before  => undef,
    require => Package["bluez-utils"],
  } # Package
} # class bluetooth::disable
