# Class: users::dev
#
# This module manages the dev users
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
class users::dev {
@group{ 'aaslam':
    ensure => present,
    gid => '1068',
    tag => 'dev'
}
 
@user { 'aaslam':
    shell => '/bin/bash',
    uid => '1068',
    ensure => 'present',
    gid => '1068',
    password => '$1$IRo9LRna$2WIjlRjUoiZ25GIpEEriK/',
    comment => 'Ali Aslam',
    groups => ['aaslam', 'build-devel', 'logs','release'],
    home => '/home/aaslam',
    tag => 'dev',
    managehome => true,
    require => Group[['aaslam', 'build-devel', 'logs', 'release']]
}

@group{ 'cconnors':
    ensure => present,
    gid => '1069',
    tag => 'dev'
}
 
@user { 'cconnors':
    shell => '/bin/bash',
    uid => '1069',
    ensure => 'present',
    gid => '1069',
    password => '$1$fojOsSFE$xufQA0uNTVGRBi0cBbHUK1',
    comment => 'Chris Connors',
    groups => ['cconnors', 'build-devel', 'logs','release'],
    home => '/home/cconnors',
    tag => 'dev',
    managehome => true,
    require => Group[['aaslam', 'build-devel', 'logs', 'release']]
}
 

@group{ 'cormsby':
    ensure => present,
    gid => '1009',
    tag => 'dev'
}
 
@user { 'cormsby':
    shell => '/bin/bash',
    uid => '1009',
    ensure => 'present',
    gid => '1009',
    password => '$1$E6gc5Ri6$yBldrF7ewqQlaN.kMUgaW1',
    comment => 'Chris Ormsby',
    groups => ['cormsby', 'release'],
    home => '/home/cormsby',
    tag => 'dev',
    managehome => true,
    require => Group[['cormsby', 'release']]
}         

@group{ 'rgable':
    ensure => present,
    gid => '10025',
    tag => 'dev'
}
 
@user { 'rgable':
    shell => '/bin/bash',
    uid => '10025',
    ensure => 'present',
    gid => '10025',
    password => '$1$mM8YxKNT$J/Wh/o0JTOXZWDmVjBGxA/',
    comment => 'Robert Gable',
    groups => ['logs','release'],
    home => '/home/rgable',
    tag => 'dev',
    managehome => true,
    require => Group[['rgable', 'logs', 'release']]
}

@group{ 'bturner':
    ensure => present,
    gid => '10076',
    tag => 'dev'
}
 
@user { 'bturner':
    shell => '/bin/bash',
    uid => '10076',
    ensure => 'present',
    gid => '10076',
    password => '$1$3VeO7AAB$YTwe62OYFex6De2X9btLQ0',
    comment => 'Becca Turner',
    groups => ['logs','release'],
    home => '/home/bturner',
    tag => 'dev',
    managehome => true,
    require => Group[['bturner', 'logs', 'release']]
}       

@group{ 'jelliott':
    ensure => present,
    gid => '10021',
    tag => 'dev'
}
 
@user { 'jelliott':
    shell => '/bin/bash',
    uid => '10021',
    ensure => 'present',
    gid => '10021',
    password => '$1$0BayCpmI$SUoFVAEIhXOanyCJt2Nby1',
    comment => 'JD Elliott',
    groups => ['release'],
    home => '/home/jelliott',
    tag => 'dev',
    managehome => true,
    require => Group[['jelliott', 'release']]
}
                          

}#end of class users::dev

