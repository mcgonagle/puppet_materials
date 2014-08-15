class wordpress::dlicious inherits wordpress  {

  file { "/srv/dlicious":
    ensure  => directory,
    source  => "puppet:///modules/wordpress/wordpress-3.0.1",
    recurse => true,
    owner   => "root", group => "root", mode => "0755",
 }
  
}#end of class wordpress
