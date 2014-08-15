import "classes/*.pp"
class smartfox {

  $app_name    = "SmartFoxServer_PRO"
  $app_ver     = "1.6.6"
  $build_area  = "/usr/local/puppet"
  $install_dir = "/opt"
  $kit         = "SFSPRO-$app_ver.tar.gz"
 
  $server_port          = "443"
  $sfs_admin            = "sfs_admin"
  $sfs_pass             = "kjd73hn"
  $sfs_queuesize        = "500"
  $sfs_debug            = "false"
  $sfs_webport          = "80"
  $sfs_socket_idle      = "1260"
  $sfs_user_idle        = "1260" 
  $sfs_video_audio_port = "1935"
 
 common::unarchive::tar-gz{"SFSPRO_linux64_1.6.6":
    file => "SFSPRO_linux64_1.6.6.tar.gz",
    untared_file => "${app_name}_${app_ver}",
    module_url => "puppet:///modules/smartfox/deploy",
    destination => "/opt", }

  file {"${install_dir}/${app_name}_${app_ver}/Server/config.xml":
    content   => template("smartfox/smartfox-config.xml.erb"),
    owner => "root", group => "root", mode => "0644",
    require => Common::Unarchive::Tar-gz["SFSPRO_linux64_1.6.6"], }

  file {"${install_dir}/${app_name}_${app_ver}/Server/bluebox.properties":
    content   => template("smartfox/smartfox-bluebox.properties.erb"),
    owner => "root", group => "root", mode => "0644", 
    require => Common::Unarchive::Tar-gz["SFSPRO_linux64_1.6.6"], }

  file {"${install_dir}/${app_name}_${app_ver}/Server/webserver/cfg/jetty.xml":
    content   => template("smartfox/smartfox-jetty.xml.erb"),
    owner => "root", group => "root", mode => "0644", 
    require => Common::Unarchive::Tar-gz["SFSPRO_linux64_1.6.6"], }

  file {"${install_dir}/${app_name}_${app_ver}/Server/license.sfl":
    source => ["puppet:///modules/smartfox/licenses/license.sfl.${hostname}",
	       "puppet:///modules/smartfox/licenses/license.sfl.${role}",
	       "puppet:///modules/smartfox/licenses/license.sfl.${zone}",
	       "puppet:///modules/smartfox/licenses/license.sfl"],
    owner => "root", group => "root", mode => "0755", 
    require => Common::Unarchive::Tar-gz["SFSPRO_linux64_1.6.6"], }

  file {"${install_dir}/${app_name}_${app_ver}/Server/sfsExtensions/ManChatXT.as":
    source => "puppet:///modules/smartfox/ManChatXT.as",
    owner => "root", group => "root", mode => "0755", 
    require => Common::Unarchive::Tar-gz["SFSPRO_linux64_1.6.6"], }

  file {"${install_dir}/${app_name}_${app_ver}/Server/conf/wrapper.conf":
    source => "puppet:///modules/smartfox/wrapper.conf",
    owner => "root", group => "root", mode => "0644", 
    require => Common::Unarchive::Tar-gz["SFSPRO_linux64_1.6.6"], }

  file { "/etc/init.d/redbox":
    content => template("smartfox/redbox.erb"),
    owner => "root", group => "root", mode => "0755", 
    require => Common::Unarchive::Tar-gz["SFSPRO_linux64_1.6.6"], }

  file { "/etc/init.d/smartfox":
    content   => template("smartfox/smartfox.erb"),
    owner => "root", group => "root", mode => "0755", 
    require => Common::Unarchive::Tar-gz["SFSPRO_linux64_1.6.6"], }

  service { "redbox":
    enable  => true,
    ensure  => running,
    pattern => "red5.policy",
    subscribe => File["/etc/init.d/redbox"], }

  service { "smartfox":
    enable    => true,
    ensure    => running,
    pattern   => "it.gotoandplay.smartfoxserver.SmartFoxServer",
    subscribe => File["/etc/init.d/smartfox"], }
}#end of class smartfox
