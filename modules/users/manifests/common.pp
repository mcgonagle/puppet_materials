# Class: users::common
#
# This module manages users::common
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
class users::common {

@group { 'sysadmin':
    ensure => 'present',
    gid => '536',
    tag => 'common'
}

@group { 'dba':
    ensure => 'present',
    gid => '537',
    tag => 'common'
}

@group { 'logs':
    ensure => 'present',
    gid => '2001',
    tag => 'common'
}  

@group { 'build-devel':
    ensure => 'present',
    gid => '532',
    tag => 'common'
}

@group { 'release':
    ensure => 'present',
    gid => '529',
    tag => 'common'
}

}#end of users::common
