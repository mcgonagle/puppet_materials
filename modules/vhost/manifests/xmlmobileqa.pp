class vhosts::xmlmobileqa inherits vhosts {
 $orgdomain = "manhunt.net"
 apache::vhosts::vhost_config_define { "xmlmobileqa":
    doc_base => "/usr/local/src/manhunt",
    doc_subdir => "web",
    conf_dir => $vhost_confdir,
    vhost_domain => $orgdomain,
    vhost_aliases => [ "xmlmobileqa.v4.$orgdomain", "xmlmobile.$orgdomain", "www.xmlmobileqa.$orgdomain", "www.i.$orgdomain" ],
    logging_conditions => 'SetEnvIf Request_URI "^/images/.*" dontlog
    SetEnvIf Request_URI "^/css/.*" dontlog
    SetEnvIf Request_URI "^/assets/.*" dontlog
    SetEnvIf Request_URI "^/chatping.*" dontlog
    SetEnvIf Request_URI "^/showpic.*" dontlog',
  }#end of apache::vhosts::vhost_config_define
}#end of apache::vhosts::xmlmobile class
