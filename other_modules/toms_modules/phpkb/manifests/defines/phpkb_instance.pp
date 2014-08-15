# phpkb.pp - PHPKB content management system
# $Id: phpkb.pp,v 1.22 2010/06/29 02:37:08 rbraun Exp $
#
# Created 12/08 by rbraun

define phpkb::instance (
  $app_ver,
  $build_area  = "/usr/local/puppet",
  $install_dir = "/var/www/html",
  $primary_host = false,
  $kb_admin    = "admin",
  $kb_pw       = "admin",
  $kb_email    = "help@orgdomain",
  $kb_fullname = "Help",
  $kb_dbserver = "localhost",
  $kb_dbuser   = "phpkb",
  $kb_dbpass,
  $kb_dbname   = "phpkb",
  $kb_sitename = "Help",
  $kb_slogan   = "",
  $kb_siteurl  = "http://help.$domain",
  $kb_copyright = "Copyright © 2001-2010 Online Buddies, Inc.",
  $apache_log_rotator = "/usr/sbin/rotatelogs"
) {
  $app_name    = "phpkb"
  $kit         = "$app_name-$app_ver.tar.gz"

  remotefile { "$build_area/KITS/$kit":
    source  => $kit,
    repo    => ftp,
    before  => Tarextract [ "$install_dir/$app_name" ],
  }
  tarextract { "$install_dir/$app_name":
    source      => "$build_area/KITS/$kit",
    directory   => $install_dir,
    compression => "gzip",
    uid         => root,
    newfile     => "$app_name/index.php",
  }
  case $app_ver {
      "6.0": {
        file { "$install_dir/$app_name":
          ensure    => "${app_name}v6",
          require   => Tarextract [ "$install_dir/$app_name" ],
        }
      }
      "2.0": {
        file { "$install_dir/$app_name":
          ensure    => "${app_name}v2",
          require   => Tarextract [ "$install_dir/$app_name" ],
        }
      }
  }

  remotefile { "$build_area/KITS/mhnet-1810.diff":
    source    => "$orgname/phpkb/mhnet-1810.diff",
    owner => root, group => root,
  }

  # Patch recommended by vendor Ajay Chadha, ticket MHNET-1810
  exec { "patch -b -p0 advance-search.php < $build_area/KITS/mhnet-1810.diff":
    cwd     => "$install_dir/$app_name",
    creates => "$install_dir/$app_name/advance-search.php.orig",
    require => [ Remotefile [ "$build_area/KITS/mhnet-1810.diff"],
                 File [ "$install_dir/$app_name" ] ],
  }
  case $primary_host {
    true: {
      #       # temp for Cornelia 5/18/09 put back when this file is finished

      # On the development/QA host, don't update these files.
      # This allows them to be modified by the application in place.

      #       file { "$install_dir/$app_name/admin/include/configuration.php":
      #         content   => template("phpkb-configuration.php.tpl"),
      #         owner     => root, group => root, mode => 644,
      #         require   => File [ "$install_dir/$app_name" ],
      #       }
      #       # temp for Cornelia 5/18/09 put back when this file is finished
      #       file { "$install_dir/$app_name/admin/default-language/english.php":
      #         content   => template("phpkb-english.php.tpl"),
      #         owner     => root, group => root, mode => 644,
      #         require   => File [ "$install_dir/$app_name" ],
      #       }
    }
    default: {
      file { "$install_dir/$app_name/admin/include/configuration.php":
        content   => template("phpkb-configuration.php.tpl"),
        owner     => root, group => root, mode => 644,
        require   => File [ "$install_dir/$app_name" ],
      }

      remotefile { "$install_dir/$app_name/admin/default-language/english.php":
        source    => "$orgname/phpkb/english.php",
        owner     => root, group => root, mode => 644,
        require   => File [ "$install_dir/$app_name" ],
      }
    }
  }

  phpkb::language_files { ["fr.php", "de.php", "it.php", "pt-br.php", "es.php" ]:
    install_dir  => $install_dir,
    primary_host => $primary_host,
    require      => File [ "$install_dir/$app_name" ],
  }

  vhost_define { help:
    doc_subdir => phpkb,
    rotatelogs => $apache_log_rotator,
    vhost_aliases => [ "help.$domain", "phpkb.$domain" ],
    rewrite_rules => "RewriteRule ^/article-(.*)\\.html$ question.php?ID=\$1 [R,NE,L]
    RewriteRule ^/category-(.*)\\.html$ category.php?catID=\$1 [R,NE,L]
    ",
    restricted_path => "admin",
  }
}

define phpkb::language_files (
  $install_dir,
  $primary_host
) {
  $app_name = "phpkb"

  case $primary_host {
    # On the development/QA host, simply make sure the language files
    # are present and owned by apache.  This allows them to be modified
    # by the application in place.

    true: {
      file { "$install_dir/$app_name/admin/languages/$name":
        ensure    => present,
        owner     => apache, group => apache, mode => 644,
      }
    }

    # Populate all other hosts from the repository on ovulator01.

    default: {
      remotefile { "$install_dir/$app_name/admin/languages/$name":
        source    => "$orgname/phpkb/$name",
        owner     => root, group => root, mode => 644,
      }
    }
  }
}
