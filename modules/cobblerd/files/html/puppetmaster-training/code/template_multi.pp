file { "/etc/warning":
  ensure  => present,
  content => template("${module_name}/header.erb", "${module_name}/warning.erb"),
}
