# Class: yum::config
#
# This module manages yum::config
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
class yum::config {

     augeas {"yum.conf metadata expire = 1":
          context => "/files/etc/yum.conf/main/",
          changes => ["set metadata_expire 1"],
          onlyif => "match other_value size > 0", }


}
