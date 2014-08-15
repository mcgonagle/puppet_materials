# source_compile.pp
#
# This will download a tarball from the pkgs directory on the puppet server,
# and run the standard configure / make / make install procedures.  Use
# this only if no rpm is available for a desired application.
#
# Created 12/07 by rbraun

# Fetch a given tarball ($app_name) from the repository
# (ftp or puppet, use ftp for speed), decompress it ($compression can
# be tar.gz, .tgz, or tar.bz2), invoke its 'configure' script with
# specified $compile_opts, and then 'make install'.

define manhunt::source_compile (
  $app_name, 
  $app_ver, 
  $compile_opts   = "",
  $build_area     = "/usr/local/puppet",
  $kit_type       = ".tar.gz", 
  $make_target    = "", 
  $time_out       = 300,
  $install_target = "install",
  $kit_location   = "puppet",
  $result         = "$build_area/$app_name-$app_ver/$app_name" 
){

  $kit = "$app_name-$app_ver$kit_type"

  $compression = $kit_type ? {
    ".tar.gz"  => gzip,
    ".tgz"     => gzip,
    ".tar.bz2" => bzip, default => false
  }

  case $kit_location {
    puppet: {
      remotefile { "$build_area/KITS/$kit":
        source => "common/pkgs/$kit",
        before => Tarextract["$build_area/KITS/$kit"],
      }
    }
    ftp: {
      remotefile { "$build_area/KITS/$kit":
        source => $kit,
        repo   => $kit_location,
        before => Tarextract["$build_area/KITS/$kit"],
      }
    }
  }
  manhunt::tarextract { "$build_area/KITS/$kit":
    source      => "KITS/$kit",
    compression => $compression,
    directory   => $build_area,
    newfile     => "$app_name-$app_ver",
    require     => Remotefile [ "$build_area/KITS/$kit" ],
  }
  exec { "$build_area/$app_name-$app_ver/configure $compile_opts":
    alias   => "$app_name configure",
    cwd     => "$build_area/$app_name-$app_ver",
    timeout => $time_out,
    path    => [ "/usr/bin", "/bin" ],
    creates => "$build_area/$app_name-$app_ver/config.status",
    require => Tarextract [ "$build_area/KITS/$kit" ],
    before  => Exec [ "$app_name make $install_target" ],
  }
  exec { "echo $app_name-$app_ver ; make $make_target && make $install_target":
    alias   => "$app_name make $install_target",
    cwd     => "$build_area/$app_name-$app_ver",
    path    => [ "/usr/bin", "/bin" ],
    timeout => $time_out,
    creates => "$result",
  }
}#end of manhunt::source_compile define
