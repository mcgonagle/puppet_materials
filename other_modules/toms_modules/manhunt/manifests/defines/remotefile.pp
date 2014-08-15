# remotefile.pp
# $Id: remotefile.pp,v 1.10 2010/06/16 21:13:08 rbraun Exp $
#
# Created 12/03/08 by rbraun

# This is still a bit hacked together, the main idea is to provide a migration path
# away from the built-in puppet fileserver (with its inefficient bucketing
# mechanism) toward simply invoking ftp 'wget'.  Invoke it with $name set to
# the full path name of the destination file.  The source basedir will be
# (ftp://server/) depot/source unless updated.

# File-bucketing is still needed for config files that change.  If you find 
# yourself using this for configs, consider templates instead.

# default value of fileserver is taken from site.pp values $server_local/$fileserver

define manhunt::remotefile($source = false,
                  $fileserver = unset,
                  $repo = "puppet",
                  $port = 8140,
                  $basedir = unset,
                  $owner = 0, $group = 0, $mode = 644,
                  $recurse = false,
                  $ignore = [ ".svn", ".git", "RCS", ",v" ],
                  $backup = false) {

  $source_real     = $source ? { false => $name, default => $source }

  case $repo {
    puppet: {
      $base_path = $basedir ? { unset => "files", default => $basedir }
      $fileserver_real = $fileserver ? { unset => $server_main, default => $fileserver }

      case $port {
        false:   { $source_uri = "puppet://$fileserver_real/$base_path/$source_real" }
        default: { $source_uri = "puppet://$fileserver_real:$port/$base_path/$source_real" }
      }
      file { $name:
        source =>  $source_uri,
        ignore =>  $ignore,
        mode =>    $mode,
        owner =>   $owner,
        group =>   $group,
        recurse => $recurse,
        backup =>  $backup,
      }
    }
    ftp: {
      $base_path = $basedir ? { unset => "depot/source", default => $basedir }
      $destpath = generate ("/bin/sh", "-c", "echo -n `dirname $name`")
      $destfile = generate ("/bin/sh", "-c", "echo -n `basename $name`")
      $opt      = $recurse ? { true => "-r", default => "" }
      $fileserver_real = $fileserver ? { unset => $server_local, default => $fileserver }

      exec {"wget -q $opt ftp://$fileserver_real/$base_path/$source_real && chown $owner.$group /tmp/$destfile && chmod $mode /tmp/$destfile && mv /tmp/$destfile $destpath":
        cwd     => "/tmp",
        creates => "$name",
      }#end of exec
    }#end of ftp type
  }#end of case repo
}#end of manhunt::remotefile define
