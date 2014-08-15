# manhunt_cron_file.pp
# Created 12/07 by rbraun

define cron::manhunt_cron_file (
  $script_name,
  $mode = 555,
  $owner = root
  ) {
  $orgname = extlookup("orgname")
  $script_dir = "/usr/local/${orgname}/cron"

  file { "$script_dir/$script_name":
    mode => $mode, owner => $owner, group => root,
    require => File["/usr/local/${orgname}"],
    source => "puppet:///modules/cron/mh_cron_scripts/${script_name}",
  }
 }
