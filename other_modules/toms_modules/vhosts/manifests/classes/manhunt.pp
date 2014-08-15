class vhosts::manhunt inherits vhosts {
 $orgdomain = "manhunt.net" 
 vhosts::vhost{"www":
    vhost_aliases => [ "www.v4.$orgdomain", "www.$orgdomain", "www.manhunt.com", "manhunt.com", "beta.$orgdomain", "www-qa.v4.$orgdomain", "$orgdomain", "www-staging.$orgdomain" ],
    logging_conditions => 'SetEnvIf Request_URI "^/images/.*" dontlog
    SetEnvIf Request_URI "^/css/.*" dontlog
    SetEnvIf Request_URI "^/assets/.*" dontlog
    SetEnvIf Request_URI "^/chatping.*" dontlog
    SetEnvIf Request_URI "^/showpic.*" dontlog',
    path_aliases =>   "Alias /sf /usr/share/pear/data/symfony/web/sf
    Alias /tour /var/www/html/mh/login/v4/tour
    Alias /mh /var/www/html/mh",

    error_documents => "
    ErrorDocument 403 http://www.manhunt.net/index.php/error/403    
    ErrorDocument 404 http://www.manhunt.net/index.php/error/404
    ErrorDocument 500 http://www.manhunt.net/index.php/error/500",

    rewrite_rules => "RewriteCond %{HTTP_HOST}    !^www\\.v4\\.manhunt\\.net [NC]
    RewriteCond %{HTTP_HOST}    !^www-staging\\.manhunt\\.net [NC]
    RewriteCond %{HTTP_HOST}    !^www-qa\\.v4\\.manhunt\\.net [NC]
    RewriteCond %{HTTP_HOST}    !^www\\.manhunt\\.net [NC]
    RewriteCond %{HTTP_HOST}    !^$ 
    RewriteRule ^/(.*)          http://www.manhunt.net/\$1 [L,R=301]
    RewriteCond %{REQUEST_URI}  ^(/account/purchase|/billing/purchase|/billing/processInteracPayment|/billing/interacReceipt|/billing/interac|/billing/processInterac)$ [NC]    RewriteRule ^/(.*)          https://billing.manhunt.net/account/purchase [L,R]",
  }#end of vhost "www"

 vhosts::vhost{"www${hostid}.v4":
    vhost_aliases => [ "www${hostid}.v4.waltham.${orgdomain}", "www${hostid}.waltham.${orgdomain}" ],
    logging_conditions => 'SetEnvIf Request_URI "^/images/.*" dontlog
    SetEnvIf Request_URI "^/css/.*" dontlog
    SetEnvIf Request_URI "^/assets/.*" dontlog
    SetEnvIf Request_URI "^/chatping.*" dontlog
    SetEnvIf Request_URI "^/showpic.*" dontlog',
    enable_server_status => true,
    path_aliases =>   "Alias /sf /usr/share/pear/data/symfony/web/sf
    Alias /tour /var/www/html/mh/login/v4/tour
    Alias /mh /var/www/html/mh",
    error_documents => "
    ErrorDocument 403 http://www.manhunt.net/index.php/error/403
    ErrorDocument 404 http://www.manhunt.net/index.php/error/404
    ErrorDocument 500 http://www.manhunt.net/index.php/error/500",
    rewrite_rules => "RewriteCond %{HTTP_HOST}    !^$hostname\\..+?\\.manhunt\\.net [NC]
    RewriteCond %{HTTP_HOST}    !^$
    RewriteRule ^/(.*)          http://www.manhunt.net/\$1 [L,R]",
  }#end of vhosts::vhost "www${hostid}.v4"

  #used to serve the  status page
  vhosts::vhost{"${fqdn}":
    vhost_aliases => ["${fqdn}"],
    logging_conditions => 'SetEnvIf Request_URI "^/images/.*" dontlog
    SetEnvIf Request_URI "^/css/.*" dontlog
    SetEnvIf Request_URI "^/assets/.*" dontlog
    SetEnvIf Request_URI "^/chatping.*" dontlog
    SetEnvIf Request_URI "^/showpic.*" dontlog',
    enable_server_status => true,
    path_aliases =>   "Alias /sf /usr/share/pear/data/symfony/web/sf
    Alias /tour /var/www/html/mh/login/v4/tour
    Alias /mh /var/www/html/mh",
    error_documents => "
    ErrorDocument 403 http://www.manhunt.net/index.php/error/403
    ErrorDocument 404 http://www.manhunt.net/index.php/error/404
    ErrorDocument 500 http://www.manhunt.net/index.php/error/500",
    rewrite_rules => "RewriteCond %{HTTP_HOST}    !^$hostname\\..+?\\.manhunt\\.net [NC]
    RewriteCond %{HTTP_HOST}    !^$
    RewriteRule ^/(.*)          http://www.manhunt.net/\$1 [L,R]",
  }#end of vhosts::vhost 

 vhosts::vhost{"gps":
    doc_base => "/usr/local/src/manhunt_gps",
    doc_subdir => "web",
    vhost_aliases => [ "gps.v4.$orgdomain", "gps.$orgdomain", "www.gps.$orgdomain", "i.$orgdomain", "www.i.$orgdomain", "gps-staging.$orgdomain" ],
    logging_conditions => 'SetEnvIf Request_URI "^/images/.*" dontlog
    SetEnvIf Request_URI "^/css/.*" dontlog
    SetEnvIf Request_URI "^/assets/.*" dontlog
    SetEnvIf Request_URI "^/chatping.*" dontlog
    SetEnvIf Request_URI "^/showpic.*" dontlog',
  }#end of vhosts::vhost

 vhosts::vhost{"newmobile":
    doc_base => "/usr/local/src/manhunt_mobile",
    doc_subdir => "web",
    vhost_aliases => [ "newmobile.v4.$orgdomain", "mobile.$orgdomain", "www.mobile.$orgdomain", "www.newmobile.$orgdomain", "m.$orgdomain", "www.m.$orgdomain", "mobile-staging.$orgdomain" ],
    logging_conditions => 'SetEnvIf Request_URI "^/images/.*" dontlog
    SetEnvIf Request_URI "^/css/.*" dontlog
    SetEnvIf Request_URI "^/assets/.*" dontlog
    SetEnvIf Request_URI "^/chatping.*" dontlog
    SetEnvIf Request_URI "^/showpic.*" dontlog',
    rewrite_rules => "RewriteCond %{HTTP_HOST}    ^mobile\\.manhunt\\.net [NC]
    RewriteCond %{HTTP_HOST}    !^$
    RewriteRule ^/(.*)          http://newmobile.manhunt.net/\$1 [L,R]",
  }#end of vhosts::vhost

 vhosts::vhost{"my":
    vhost_aliases => [ "my.v4.$orgdomain" ],
    logging_conditions => 'SetEnvIf Request_URI "^/images/.*" dontlog
    SetEnvIf Request_URI "^/css/.*" dontlog
    SetEnvIf Request_URI "^/assets/.*" dontlog
    SetEnvIf Request_URI "^/chatping.*" dontlog
    SetEnvIf Request_URI "^/showpic.*" dontlog',
    rewrite_rules => "RewriteCond %{HTTP_HOST}    ^my\\.manhunt\\.net [NC]
    RewriteCond %{HTTP_HOST}    !^$
    RewriteRule ^/(.+)$          http://www.manhunt.net/externalProfile/\$1 [L,R]
    RewriteRule !^/(.+)$         http://www.manhunt.net/ [L,R]",
  }#end of vhosts::vhost

 #xmlmobile
 vhosts::vhost{"xmlmobile":
    doc_base => "/usr/local/src/manhunt_xmlmobile",
    doc_subdir => "web",
    vhost_aliases => [ "xmlmobile.v4.$orgdomain", "xmlmobile.$orgdomain", "www.xmlmobile.$orgdomain", "xmlmobile-a.$orgdomain", "www.i.$orgdomain", "xmlmobile-staging.$orgdomain" ],
    logging_conditions => 'SetEnvIf Request_URI "^/images/.*" dontlog
    SetEnvIf Request_URI "^/css/.*" dontlog
    SetEnvIf Request_URI "^/assets/.*" dontlog
    SetEnvIf Request_URI "^/chatping.*" dontlog
    SetEnvIf Request_URI "^/showpic.*" dontlog',
  }#end of apache::vhosts::vhost_config_define 

 #xmlmobile_i
 vhosts::vhost{"xmlmobile_i":
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
  }#end of vhosts::vhost_config_define
}#end of vhosts::vhost
