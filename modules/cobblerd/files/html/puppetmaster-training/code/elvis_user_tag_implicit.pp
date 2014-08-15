class legends {
  user { 'elvis':
    ensure => present,
  }
}
class clowns {
  user { 'bozo':
    ensure => present,
  }
}
include clowns,legends
