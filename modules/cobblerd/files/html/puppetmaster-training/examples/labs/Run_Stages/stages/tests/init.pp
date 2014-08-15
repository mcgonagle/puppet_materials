include stages
class { "sshd::packages": stage => "first" }
class { "sshd": }
