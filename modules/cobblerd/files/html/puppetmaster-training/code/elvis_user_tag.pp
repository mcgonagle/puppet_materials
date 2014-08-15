@user { 'elvis':
  ensure => present,
  tag    => 'hounddog',
}

User <| tag == 'hounddog' |>
