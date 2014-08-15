file { "/etc/ssh_config":
  mode   => "0440",
  owner  => "root",
  group  => "root",
  source => "puppet:///modules/ssh/ssh_config",
}
