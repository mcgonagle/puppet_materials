class apache($version="2.0", $home="/var/www") {
  ...
}

class php {
  include apache
  ...
}

node webserver {
  class { "apache":
    version => "1.3.13"
  }
}
