# reload_linker.pp
# $Id: reload_linker.pp,v 1.9 2009/11/25 16:53:43 wflynn Exp $
# Helper to reload linker cache after library installs
define manhunt::reload_linker($conf) {
  exec { "/sbin/ldconfig -v && echo $conf":
    user       => root,
    group      => root,
    # Only if the modtime of our incoming config is newer (greater than) that of the linker cache       
    unless     => "/usr/bin/test `stat -c %Y $conf` -gt `stat -c %Y /etc/ld.so.cache`",
    refreshonly => true,
  }
}
