class vhosts::cms inherits vhosts {
  
  vhosts::vhost { "jonathancrutchley.com":
    orgdomain     => "jonathancrutchley.com",
    doc_base      => "/srv/jonathancrutchley.com",
    doc_subdir    => "wordpress",
    vhost_aliases => [
                       "www.jonathancrutchley.com",
                       "${zone}.jonathancrutchley.com"
                      ],
    logging_conditions => 'SetEnvIf Request_URI "^/images/.*" dontlog
    SetEnvIf Request_URI "^/css/.*" dontlog
    SetEnvIf Request_URI "^/assets/.*" dontlog
    SetEnvIf Request_URI "^/chatping.*" dontlog
    SetEnvIf Request_URI "^/showpic.*" dontlog',
    path_aliases =>   "",
    error_documents => "
      ErrorDocument 403 http://${zone}.jonathancrutchley.com/index.php?error=403
      ErrorDocument 404 http://${zone}.jonathancrutchley.com/index.php?error=404
      ErrorDocument 500 http://${zone}.jonathancrutchley.com/index.php?error=500",
  }


  vhosts::vhost { "manhuntdiario.com":
    orgdomain     => "manhuntdiario.com",
    doc_base      => "/srv/manhuntdiario.com",
    doc_subdir    => "wordpress",
    vhost_aliases => [
                       "www.manhuntdiario.com",
                       "${zone}.manhuntdiario.com"
                      ],
    logging_conditions => 'SetEnvIf Request_URI "^/images/.*" dontlog
    SetEnvIf Request_URI "^/css/.*" dontlog
    SetEnvIf Request_URI "^/assets/.*" dontlog
    SetEnvIf Request_URI "^/chatping.*" dontlog
    SetEnvIf Request_URI "^/showpic.*" dontlog',
    path_aliases =>   "",
    error_documents => "
      ErrorDocument 403 http://${zone}.manhuntdiario.com/index.php?error=403
      ErrorDocument 404 http://${zone}.manhuntdiario.com/index.php?error=404
      ErrorDocument 500 http://${zone}.manhuntdiario.com/index.php?error=500",
  }

  vhosts::vhost { "blog.bigbearden.com":
    orgdomain     => "blog.bigbearden.com",
    doc_base      => "/srv/blog.bigbearden.com",
    doc_subdir    => "wordpress",
    vhost_aliases => [
                       "blog.bigbearden.com",
                       "${zone}blog.bigbearden.com"
                      ],
    logging_conditions => 'SetEnvIf Request_URI "^/images/.*" dontlog
    SetEnvIf Request_URI "^/css/.*" dontlog
    SetEnvIf Request_URI "^/assets/.*" dontlog
    SetEnvIf Request_URI "^/chatping.*" dontlog
    SetEnvIf Request_URI "^/showpic.*" dontlog',
    path_aliases =>   "",
    error_documents => "
      ErrorDocument 403 http://${zone}blog.bigbearden.com/index.php?error=403
      ErrorDocument 404 http://${zone}blog.bigbearden.com/index.php?error=404
      ErrorDocument 500 http://${zone}blog.bigbearden.com/index.php?error=500",
  }
  
  vhosts::vhost { "manhuntdaily":
    vhost_domain  => "com",
    doc_base      => "/srv/manhuntdaily.com",
    doc_subdir    => "wordpress",
    log_base => "/etc/httpd/logs/manhuntdaily.com",
    vhost_aliases => [
                       "www.manhuntdaily.com",
                       "${zone}.manhuntdaily.com"
                      ],
    logging_conditions => 'SetEnvIf Request_URI "^/images/.*" dontlog
    SetEnvIf Request_URI "^/css/.*" dontlog
    SetEnvIf Request_URI "^/assets/.*" dontlog
    SetEnvIf Request_URI "^/chatping.*" dontlog
    SetEnvIf Request_URI "^/showpic.*" dontlog
    SetEnvIf Request_URI "^/favicon.ico" dontlog',
    
    path_aliases =>   "",
    error_documents => "
      ErrorDocument 403 http://${zone}.manhuntdaily.com/index.php?error=403
      ErrorDocument 404 http://${zone}.manhuntdaily.com/index.php?error=404
      ErrorDocument 500 http://${zone}.manhuntdaily.com/index.php?error=500",
  }
  

 vhosts::vhost { "cmsitdv01":
    vhost_domain => "cam.manhunt.net",
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

}
