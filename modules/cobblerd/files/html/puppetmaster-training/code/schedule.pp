schedule { daily: period => daily, range => '2-4' }
exec { '/usr/bin/apt-get update': schedule => daily }
