# Class: users::dba
#
# This module manages the dba users
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
class users::dba {

@group { 'sfrattura':
    ensure => present,
    gid => '10004',
    tag => 'dba'
}

@user { 'sfrattura':
    shell => '/bin/bash',
    uid => '10004',
    ensure => 'present',
    gid => '10004',
    password => '$1$4zDo3.lC$zaCGyjNjXixfew6S0e/t80',
    comment => 'Sandro Fratura',
    groups => ['wheel','logs','sysadmin','build-devel','dba'],
    home => '/home/sfrattura',
    managehome => true,
    require => Group[['sfrattura', 'logs', 'sysadmin', 'build-devel', 'dba']],
    tag => 'dba'
}

@group{ 'kpanacy':
    ensure => present,
    gid => '10027',
    tag => 'dba'
}

@user { 'kpanacy':
    shell => '/bin/bash',
    uid => '10027',
    ensure => 'present',
    password => '$1$JFc9qJM/$aIXy/jl/x2lnEOiWret7p0',
    gid => '10027',
    comment => 'Ken Panacy',
    groups => ['wheel','logs','sysadmin','build-devel','dba'],
    home => '/home/kpanacy',
    managehome => true,
    require => Group[['kpanacy', 'logs', 'sysadmin', 'build-devel', 'dba']],
    tag => 'dba'
}


@group { 'rpeachey':
    ensure => present,
    gid => '10075',
    tag => 'dba'
}

@user { 'rpeachey':
    shell => '/bin/bash',
    uid => '10075',
    ensure => 'present',
    gid => '10075',
    password => '$1$fwNCbMUu$mcS4fAGAJQVGAfYmJ1SF60',
    comment => 'Raymond Peachey',
    groups => ['wheel','logs','sysadmin','build-devel','dba'],
    home => '/home/rpeachey',
    managehome => true,
    require => Group[['rpeachey', 'logs', 'sysadmin', 'build-devel', 'dba']],
    tag => 'dba'
}

}#end of class users::dba
 
