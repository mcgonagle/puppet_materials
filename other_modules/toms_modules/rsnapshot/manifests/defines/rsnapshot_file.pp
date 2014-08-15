define rsnapshot::file(
  $template_name = "rsnapshot.conf.erb"
) {
 $file_name = "${name}"

#$template_name = extlookup("${role}::rsnapshot::${service_name}::template_name","rsnapshot.conf.erb")

  file {"/etc/rsnapshot.conf.d/${name}_rsnapshot.conf":
    content => template("rsnapshot/rsnapshot.conf.d/${template_name}"),
    owner => "root", group => "root", mode => "0600", }

}#end of rsnapshot::file define
