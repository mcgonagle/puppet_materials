# Class: yumrepos
#
# This module manages yumrepos
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
class yumrepos () inherits yumrepos::params {
  include yumrepos::centos
  include yumrepos::centosplus
  include yumrepos::centosupdates
  include yumrepos::elff
  include yumrepos::epel
  include yumrepos::epel-testing
  include yumrepos::manhunt
  include yumrepos::mysql-enterprise
  include yumrepos::puppet-enterprise
  include yumrepos::remi
  include yumrepos::rpmforge
  include yumrepos::sun-java

}
