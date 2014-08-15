# Class: nagios::naginatorpatch
#
# This module manages nagios::naginatorpatch
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
class nagios::naginatorpatch {

   $naginator_patch_file = "/usr/lib/ruby/gems/1.8/gems/puppet-2.6.8/lib/puppet/provider/naginator.rb.patch"

   file {"${naginator_patch_file}":
      source => "puppet:///modules/nagios/naginator.rb.patch",
      owner => "root", group => "root", mode => "0660", 
      require => Package[nagios], }

   #exec {"patch < naginator.rb.patch":
      #path => ["/bin", "/usr/bin", "/usr/sbin/"],
      #cwd => "/usr/lib/ruby/site_ruby/1.8/puppet/provider/",
      #subscribe => File["${naginator_patch_file}"],
      #onlyif => "/bin/false", }

}
