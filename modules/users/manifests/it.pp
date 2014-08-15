# Class: users::it
#
# This module manages the it users
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class users::it {

@group{ 'tmcgonagle':
    ensure => present,
    gid => '10007',
    tag => 'it'
}

@user { 'tmcgonagle':
    shell => '/bin/bash',
    uid => '10007',
    ensure => 'present',
    password => '$1$BtrB/iaY$rDtyDZvqxuoXAm0sVHYNl0',
    gid => '10007',
    comment => 'Thomas A. McGonagle',
    groups => ['wheel','build-devel', 'logs','sysadmin','dba'],
    home => '/home/tmcgonagle',
    tag => 'it',
    managehome => true,
    require => Group[['tmcgonagle','logs','build-devel', 'sysadmin', 'dba']]
}


@group { 'wflynn':
    ensure => present,
    gid => '10010',
    tag => 'it'
}

@user { 'wflynn':
    shell => '/bin/bash',
    uid => '10010',
    ensure => 'present',
    gid => '10010',
    password => '$1$ic3Pxoef$7mYqLSpN1DHNNH2cbd40N/',
    comment => 'Bill Flynn',
    groups => ['wheel','logs','sysadmin','build-devel', 'dba'],
    home => '/home/wflynn',
    tag => 'it',
    managehome => true,
    require => Group[['wflynn', 'logs', 'sysadmin', 'build-devel', 'dba']]
}

@group { 'jmarshal':
    ensure => present,
    gid => '10014',
    tag => 'it'
}

@user { 'jmarshal':
    shell => '/bin/bash',
    uid => '10014',
    ensure => 'present',
    gid => '10014',
    password => '$1$0sv0YbNc$uEl8JUAJzNGQWvhQ5m99Z.',
    comment => 'Joseph Marshall',
    groups => ['wheel','sysadmin'],
    home => '/home/jmarshal',
    tag => 'it',
    managehome => true,
    require => Group[['jmarshal', 'sysadmin']]
}

@group{ 'jjoy':
    ensure => present,
    gid => '10018',
    tag => 'it'
}

@user { 'jjoy':
    shell => '/bin/bash',
    uid => '10018',
    ensure => 'present',
    password => '$1$8mAGauqy$3oQC6Hf4YOqsQhMBNZjoN1',
    gid => '10018',
    comment => 'Jason Joy',
    groups => ['wheel','logs','sysadmin'],
    home => '/home/jjoy',
    tag => 'it',
    managehome => true,
    require => Group[[ 'jjoy', 'logs', 'sysadmin' ]]
}

@group { 'dcote':
    ensure => present,
    gid => '10020',
    tag => 'it'
}

@user { 'dcote':
    shell => '/bin/bash',
    uid => '10020',
    ensure => 'present',
    password => '$1$rUPNHOoN$BPq657ksVis4IUoCG3OzH1',
    gid => '10020',
    comment => 'Don Cote',
    groups => ['wheel','logs','sysadmin','build-devel', 'dba'],
    home => '/home/dcote',
    tag => 'it',
    managehome => true,
    require => Group[['dcote', 'logs', 'sysadmin','build-devel', 'dba']]
}

@group{ 'apradhan':
    ensure => 'absent',
    gid => '10029',
    tag => 'it',
    require => User['apradhan'],
}
 
@user { 'apradhan':
    shell => '/bin/bash',
    uid => '10029',
    ensure => 'absent',
    gid => '10029',
    password => '$1$SttRSB7z$38GKSxDu.HCPuFpAN53Dx0',
    comment => 'Akshat Pradhan',
    groups => ['wheel','logs','sysadmin','build-devel','dba'],
    home => '/home/apradhan',
    tag => 'it',
    managehome => true,
    #require => Group[['apradhan', 'logs', 'sysadmin', 'build-devel', 'dba']]
}

}#end of class users::it 
