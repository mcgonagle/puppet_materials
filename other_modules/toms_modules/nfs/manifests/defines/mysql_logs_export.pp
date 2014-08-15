define nfs::mysql_logs_export ( $data_dir="/data01", $mysql_instance="mysql_A" ) {
  nfs_export { "$data_dir/log/$mysql_instance":
    export_dir=>"$data_dir/log/$mysql_instance",
    export_to=>"logviewer*.manhunt.net",
    squash_uid=>"2007",
    squash_gid=>"542",
  }
}
