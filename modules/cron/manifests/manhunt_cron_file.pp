# manhunt_cron_file.pp
# Created 12/07 by rbraun

define cron::manhunt_cron_file (
  $script_name,
  $mode = 555,
  $owner = root
  ) {
  #$orgname = extlookup("orgname")
  $script_dir = "/usr/local/${product}/cron"

  file { "$script_dir/$script_name":
    source => "puppet:///modules/cron/mh_cron_scripts/${script_name}",
    owner => "root", group => "root", mode => "0755",
    require => Class["cron::config"],
  }
 }
