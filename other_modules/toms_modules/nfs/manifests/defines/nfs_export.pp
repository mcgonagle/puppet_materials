define nfs::nfs_export ( 
	$export_dir="/var/log/httpd",
	$export_to="logviewer*.manhunt.net",
	$export_opts="no_wdelay,all_squash,sync,no_subtree_check",
	$squash_uid="2001",
	$squash_gid="2001",
	$writable=false,
	$allow_export=true 
){ 

  $export_p = $allow_export ? { false => "absent", default => "present" }
  $write_p = $writable ? { true => "rw", default => "ro" }
  
  $export_line="$export_dir $export_to($write_p,$export_opts,anongid=$squash_gid,anonuid=$squash_uid)"
  
  manhunt::line { "export $export_dir to $export_to":
    file     => "/etc/exports",
    line     => "$export_line",
    ensure   => $export_p,
    notify   => Service [ "nfs" ],
  }
}#end of define nfs::nfs_export
