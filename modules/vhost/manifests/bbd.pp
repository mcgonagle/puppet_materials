class vhosts::bbd inherits vhosts {
 $orgdomain = "bigbearden.com" 
 vhosts::vhost{"www":
    vhost_aliases => [ "www.$orgdomain", "www.bigbearden.com", "bigbearden.com", "beta.$orgdomain", "alpha.$orgdomain", "$orgdomain", "www-staging.$orgdomain" ],
    logging_conditions => 'SetEnvIf Request_URI "^/images/.*" dontlog
    SetEnvIf Request_URI "^/css/.*" dontlog
    SetEnvIf Request_URI "^/assets/.*" dontlog
    SetEnvIf Request_URI "^/chatping.*" dontlog
    SetEnvIf Request_URI "^/showpic.*" dontlog',
    path_aliases =>   "Alias /sf /usr/share/pear/data/symfony/web/sf
    Alias /tour /var/www/html/mh/login/v4/tour
    Alias /mh /var/www/html/mh",
    error_documents => "
    ErrorDocument 403 http://www.bigbearden.com/index.php/error/403    
    ErrorDocument 404 http://www.bigbearden.com/index.php/error/404
    ErrorDocument 500 http://www.bigbearden.com/index.php/error/500",
    rewrite_rules => "RewriteCond %{HTTP_HOST}    !^www-staging\\.bigbearden\\.com [NC]
    RewriteCond %{HTTP_HOST}    !^alpha\\.bigbearden\\.com [NC]
    RewriteCond %{HTTP_HOST}    !^www\\.bigbearden\\.com [NC]
    RewriteCond %{HTTP_HOST}    !^$ 
    RewriteRule ^/(.*)          http://www.bigbearden.com/\$1 [L,R=301]",
  }#end of vhosts::vhost

 vhosts::vhost{"${fqdn}":
    vhost_aliases => [ "${fqdn}" ],
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
    doc_base => "/usr/local/src/bigbearden_gps",
    doc_subdir => "web",
    vhost_aliases => [ "gps.v4.$orgdomain", "gps.$orgdomain", "www.gps.$orgdomain", "i.$orgdomain", "www.i.$orgdomain", "gps-staging.$orgdomain" ],
    logging_conditions => 'SetEnvIf Request_URI "^/images/.*" dontlog
    SetEnvIf Request_URI "^/css/.*" dontlog
    SetEnvIf Request_URI "^/assets/.*" dontlog
    SetEnvIf Request_URI "^/chatping.*" dontlog
    SetEnvIf Request_URI "^/showpic.*" dontlog',
  }#end of vhosts::vhost
}
