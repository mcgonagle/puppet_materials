# vhosts::vhost.pp
#
# All-purpose vhost generator
#
# created 2/09 by rbraun

define vhosts::vhost(
  $doc_base = "/usr/local/src/manhunt",
  $doc_subdir = "web",
  $rotatelogs = "/usr/sbin/rotatelogs",
  $dest_dir = "/etc/httpd",
  $conf_dir = "/etc/httpd/conf.d",

  # vhost_domain - DNS suffix for primary name
  $orgdomain = "manhunt.net",
  $vhost_domain = "manhunt.net",

  # Set the DocumentRoot directory to this owner/uid/gid
  $doc_owner = false,
  $doc_group = apache,
  $doc_mode  = 755,

  # vhost_aliases - anything beyond vhost_name.$domain (which is QA, dev, etc)
  $vhost_aliases = [ ],

  $log_base = "/etc/httpd/logs",
  $server_admin = "support@manhunt.net",

  # rewrite_cond - defines a condition under which rewriting will take place
  $rewrite_cond = unset,

  # rewrite_rules - any after the line "rewriteengine on"
  # defines rules for the rewriting engine
  $rewrite_rules = unset,

  # restricted_path - a path name which is only available from internal IPs
  $restricted_path = unset,

  # Configuration for /server-status (only one needed per physical host)
  $enable_server_status = false,

  # Kerberos authentication
  $enable_kerberos_auth = false,
  $krb_realm = "MANHUNT.LOCAL",
  $krb_authname = "Authorization",

  # Configuration for Zend Core/Platform Console (only one needed per physical host)
  $enable_zend_console = false,

  # Configuration for Manhunt Tools (site scripts not for General Consumption) (only one needed per physical host)
  $enable_mh_tools = false,

  # Configure as secure host
  $secure_host = false,
  $cacertfile = unset,
  $certfile = "",
  $keyfile = "",

  # path aliases
  $path_aliases = "",

  # path aliases
  $logging_conditions = "",

  # custom error documents
  $error_documents = "",

  $trace_enable = "Off",
  $hostname_lookups = "Off",

  # Age of a weblog before it gets snapped
  #  and a new log started (in Seconds.  86400=1 day)
  $log_duration = "3600",
  $tcp_port = "80"
  ) {

  $vhost_name = $name
  $vhost_conf_name = $secure_host ? {
    false => "$conf_dir/vhost-${name}.conf",
    true => "$conf_dir/ssl/vhost-${name}.conf",
  }

  $subdir = $doc_subdir ? {
    unset => $name,
    default => $doc_subdir
  }

  # TBD - properly implement ServerAlias directive
  $vhost_alias_cmd = "ServerAlias $name.$domain"
  $rewrite_cmd = $rewrite_rules ? {
    unset => "",
    default => "RewriteEngine       On\n    $rewrite_rules"
  }

  $allow_list = "Allow from 127.0.0.1/8
  Allow from 192.168.0.0/16
  Allow from 172.16.0.0/16
  Allow from 38.97.106.64/26
  Allow from 206.83.81.96/27"

  $acl_restrictions = $restricted_path ? {
    unset => "",
    default => "<Directory $doc_base/$subdir/$restricted_path>
    Order deny,allow
    Deny from all
    $allow_list
    </Directory>"
  }

  $ssl_certs_root = $operatingsystem ? { RedHat => "/etc/pki/tls", default => "/etc/ssl" }

  $secure_config = $secure_host ? {
    false => "",
    true => "SSLEngine on
    SSLCertificateFile $ssl_certs_root/certs/$certfile
    SSLCertificateKeyFile $ssl_certs_root/private/$keyfile"
  }

  $intermediate_certfile = $cacertfile ? {
    unset => "",
    default => "SSLCACertificateFile $ssl_certs_root/certs/$cacertfile"
  }

  $mh_tools = $enable_mh_tools ? {
    false => "",
    true => "Alias /mhtools /var/www/html/mhtools

    <Location /mhtools>
    Options FollowSymLinks
    Order deny,allow
    Deny from all
    $allow_list
    AuthUserFile /var/www/html/mhtools/.htpasswd
    AuthGroupFile /dev/null
    AuthName \"Restricted Access\"
    AuthType Basic
    Require valid-user
    </Location>"
  }

  $zend_console = $enable_zend_console ? {
    false => "",
    true => "Alias /ZendCore /usr/local/Zend/Core/GUI

    <Location /ZendCore>
    Options FollowSymLinks
    Order deny,allow
    Deny from all
    $allow_list
    </Location>


    Alias /ZendPlatform /var/www/html/ZendPlatform

    <Location /ZendPlatform>
    Options FollowSymLinks
    Order deny,allow
    Deny from all
    $allow_list
    php_value auto_prepend_file none
    </Location>"
  }

  $server_status = $enable_server_status ? {
    false => "",
    true => "<Location /server-status>
    SetHandler server-status
    Order deny,allow
    Deny from all
    $allow_list
    </Location>

    <Location /server-info>
    SetHandler server-info
    Order deny,allow
    Deny from all
    $allow_list
    </Location>"
  }

  $kerberos_auth = $enable_kerberos_auth ? {
    false => "",
    true => "<Location />
     AuthType Kerberos
     KRBAuthRealms $krb_realm
     KrbMethodNegotiate off
     KrbSaveCredentials off
     KrbVerifyKDC off
     KrbLocalUserMapping on
     AuthName \"$krb_authname\"
     require valid-user
    </Location>"
  }


  if $secure_host {
    # Place the SSL Cert/Key files for this vhost on the system
    vhost_ssl_certs { $name:
      dest_dir => "$ssl_certs_root",
      cacertfile  => $cacertfile,
      certfile => "$certfile",
      keyfile  => "$keyfile",
    }
  }
  if $doc_owner {
    file { "$doc_base/$subdir":
      ensure => directory,
      mode => $doc_mode, owner => $doc_owner, group => $doc_group,
    }
  }
#############################################################
#templatized file definition that drives configuration
#############################################################
  file { "/etc/httpd/vhosts.d/vhost-${name}.conf":
    content => template ("vhosts/vhost-allpurpose.erb"),
    mode   => 644, owner => root, group => root,
    require => File["/etc/httpd/vhosts.d"],
  }

}# end of apache::vhosts::vhost_config_define.pp
