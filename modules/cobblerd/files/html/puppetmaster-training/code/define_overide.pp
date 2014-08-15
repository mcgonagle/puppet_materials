define ssh_config($ssh_path = '/etc/ssh') {
  file {"${ssh_path}/${name}":
    source  => "/files/puppet/${ssh_path}",
    recurse => true
  }
}
class ssh {
  ssh_config{ 'config':}
}
class ssh::secure inherits ssh {
  Ssh_config['config'] { ssh_path => '/etc/secure/ssh' }
}
