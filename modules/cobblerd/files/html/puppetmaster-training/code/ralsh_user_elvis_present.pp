user { 'elvis':
     home => '/home/elvis',
     uid => '501',
     gid => '501',
     shell => '/bin/bash',
     ensure => 'present',
     password => '!!',
}
