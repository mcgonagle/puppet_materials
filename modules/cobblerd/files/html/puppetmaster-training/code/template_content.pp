file { "/etc/warning":
  ensure  => present,
  content => template("/etc/puppet/templates/warning.erb")
}
