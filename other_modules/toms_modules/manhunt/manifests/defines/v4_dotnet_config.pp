define manhunt::v4_dotnet_config (
	$tpl = "app.yml.fe.tpl", 
	$dest_dir = "/tmp",
	$app_yml="app.yml.mh", 
	$skin="mh", 
	$shardsingleton="on", 
	$js_version="385") {
  file { "$dest_dir/$app_yml":
    content => template ( "manhunt/$tpl" ),
    owner => "root", group => "root", mode => "0644",
  }
}#endo of manhunt::v4_dotnet_config
