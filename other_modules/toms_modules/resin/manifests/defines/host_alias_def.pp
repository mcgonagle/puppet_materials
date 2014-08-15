define resin::host_alias_def (
  $host_alias
) {
  $main_domain = "${name}"

#file {"/usr/local/resin/resin/conf/resin.conf":
  file {"/tmp/resin.conf":
    content => template("resin/resin.conf.erb"),
    owner => root, group => root, mode => 0755,
  }
} #end of define resin::host_alias_def
