# Class: yumrepos::puppetlabs
#
# This module manages yumrepos::puppetlabs
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
class yumrepos::puppetlabs {

  yumrepo {"Puppet Labs":
    name => "PuppetLabs",
    descr  => "Puppet Labs Packages",
    baseurl => "http://yum.puppetlabs.com/base/",
    enabled => 1,
    priority => 99,
    gpgcheck => 0,
    metadata_expire => 1, } 

}
