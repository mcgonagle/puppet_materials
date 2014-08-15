class apache::vhosts::xmlmobile_i inherits apache::vhosts {

 $orgdomain = "manhunt.net"
 $docbase = "/usr/local/src/manhunt_xmlmobile_i"
 $docsubdir = "web"

 apache::vhosts::vhost_config_define { "xmlmobile_i":
    doc_base => "/usr/local/src/manhunt_xmlmobile_i",
    doc_subdir => "web",
    conf_dir => $vhost_confdir,
    vhost_domain => $orgdomain,
    vhost_aliases => [ "xmlmobile-i.$orgdomain" ],
    logging_conditions => 'SetEnvIf Request_URI "^/images/.*" dontlog
    SetEnvIf Request_URI "^/css/.*" dontlog
    SetEnvIf Request_URI "^/assets/.*" dontlog
    SetEnvIf Request_URI "^/chatping.*" dontlog
    SetEnvIf Request_URI "^/showpic.*" dontlog',
  }#end of apache::vhosts::vhost_config_define
}#end of apache::vhosts::xmlmobile class 
