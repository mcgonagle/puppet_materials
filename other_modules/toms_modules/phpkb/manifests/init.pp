# Class: phpkb
#
# Manages phpkb software 
# Include it to install and run phpkb with default settings
#
# Usage:
# include phpkb

class phpkb {
 include httpd
 include vhosts

 $app_name = "phpkb"
 $app_ver = "2.0"
 $kit = "$app_name-$app_ver.tar.gz"

 $build_area  = "/usr/local/puppet"
 $install_dir = "/var/www/html"
 $primary_host = "false"
 $kb_admin    = extlookup("phpkb::kb_admin")
 $kb_pw       = extlookup("phpkb::kb_pw")
 $kb_email    = "help@${orgdomain}"
 $kb_fullname = "Help"
 $kb_dbserver = extlookup("phpkb::kb_dbserver")
 $kb_dbuser   = extlookup("phpkb::kb_dbuser")
 $kb_dbpass   = extlookup("phpkb::kb_dbpass")
 $kb_dbname   = extlookup("phpkb::kb_dbname")
 $kb_sitename = "Help"
 $kb_slogan   = "" 
 $kb_siteurl  = "http://help.${domain}"
 $kb_copyright = "Copyright © 2001-2011 Online Buddies, Inc."
 $apache_log_rotator = "/usr/sbin/rotatelogs"


 common::unarchive::tar-gz{"phpkb-2.0":
    file => "${app_name}-${app_ver}.tar.gz",
    untared_file => "${app_name}v2",
    module_url => "puppet:///modules/phpkb/deploy",
    destination => "/var/www/html", }

 file{"${install_dir}/phpkbv2/advance-search.php":
   source => "puppet:///modules/phpkb/advance-search.php",
   owner => "root", group => "root", mode => "0644",
   require => Common::Unarchive::Tar-gz["${app_name}-${app_ver}"], }

 file{"${install_dir}/phpkbv2/admin/include/configuration.php":
   content => template("phpkb/phpkb-configuration.php.erb"),
   owner => "root", group => "root", mode => "0644",
   require => Common::Unarchive::Tar-gz["${app_name}-${app_ver}"], }

 file{"${install_dir}/phpkbv2/admin/default-language/english.php":
   source => "puppet:///modules/phpkb/languages/english.php",
   owner => "root", group => "root", mode => "0644",
   require => Common::Unarchive::Tar-gz["${app_name}-${app_ver}"], }

 file{"${install_dir}/phpkbv2/admin/languages/fr.php":
   source => "puppet:///modules/phpkb/languages/fr.php",
   owner => "root", group => "root", mode => "0644",
   require => Common::Unarchive::Tar-gz["${app_name}-${app_ver}"], }

 file{"${install_dir}/phpkbv2/admin/languages/de.php":
   source => "puppet:///modules/phpkb/languages/de.php",
   owner => "root", group => "root", mode => "0644",
   require => Common::Unarchive::Tar-gz["${app_name}-${app_ver}"], }

 file{"${install_dir}/phpkbv2/admin/languages/it.php":
   source => "puppet:///modules/phpkb/languages/it.php",
   owner => "root", group => "root", mode => "0644",
   require => Common::Unarchive::Tar-gz["${app_name}-${app_ver}"], }

 file{"${install_dir}/phpkbv2/admin/languages/pt-br.php":
   source => "puppet:///modules/phpkb/languages/pt-br.php",
   owner => "root", group => "root", mode => "0644",
   require => Common::Unarchive::Tar-gz["${app_name}-${app_ver}"], }

 file{"${install_dir}/phpkbv2/admin/languages/es.php":
   source => "puppet:///modules/phpkb/languages/es.php",
   owner => "root", group => "root", mode => "0644",
   require => Common::Unarchive::Tar-gz["${app_name}-${app_ver}"], }


 vhosts::vhost{"help":
    doc_base => "/var/www/html",
    doc_subdir => "phpkbv2",
    vhost_aliases => [ "help.$domain", "phpkb.$domain" ],
    rewrite_rules => "RewriteRule ^/article-(.*)\\.html$ question.php?ID=\$1 [R,NE,L]    RewriteRule ^/category-(.*)\\.html$ category.php?catID=\$1 [R,NE,L]
    ",  
    restricted_path => "admin", }
	
	

}#end of class phpkb
