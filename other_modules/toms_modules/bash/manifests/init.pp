# Class: bash
#
# Manages profile software 
# Include it to configure and manage a base bash environment
#
# Usage:
# include profile
#
# Parameters:
#
# Actions:
# Creates a default /etc/bashrc
# Creates a default /etc/profile
# Creates a custom /etc/profile.d/facter.sh
#
# Requires:
#
# Sample Usage:
#  include bash
#

class bash {
    File {
	      owner => "root", 
        group => $operatingsystem ? {
          /Darwin/ => "wheel", 
          default => "root", 
        },
        mode => "0755", }

    Package {
        provider => $operatingsystem ? {
          /Darwin/ => "darwinport",
          default => "yum", 
        },
    }


    #package{"bash-completion": ensure => installed, }#end of selector

    file { "/etc/bashrc":
        content => template("bash/common/bashrc.erb"), }

    file { "/etc/profile":
        content => template("bash/common/profile.erb"), }

    file { "/etc/profile.d":
        ensure => directory,
        require => File["/etc/profile"],}

    file { "/etc/profile.d/facter.sh":
	      source => "puppet:///modules/bash/facter.sh", 
        require => File["/etc/profile.d"],}

}#end of class bash
