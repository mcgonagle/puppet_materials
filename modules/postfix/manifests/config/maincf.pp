# Class: postfix::config::maincf
#
# This module manages postfix::config::maincf
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
define postfix::config::maincf(
  $maincf_path = "/etc/postfix",
  $myhostname = "${fqdn}",
  $mydomain = "${domain}",
  $mynetworks = "127.0.0.1",
  $inet_interfaces = "${ipaddress}",
  $relay_domains = "${domain}"
) {

  file { "${maincf_path}/main.cf":
   content => template("postfix/main.cf.erb"),
   owner => "root", group => "root", mode => "0644",
   require => Class["postfix::install"], }


}#end of postfix::config::maincf
