class wordpress::manhunthookers inherits wordpress {
 file{"/srv/manhunthookers":
    ensure => directory,
    source => "puppet:///modules/wordpress/wordpress",
    recurse => true,
    owner => "root", group => "root", mode => "0755", }

}#end of class wordpress
