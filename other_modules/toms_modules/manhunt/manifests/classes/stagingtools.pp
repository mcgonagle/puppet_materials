class manhunt::stagingtools inherits manhunt {
  $source_tarball    = "StagingTools.tgz"
  $build_area        = "/var/lib/puppet"
  $kits_dir          = "$build_area/KITS"
  $wget              = "wget -q"
  $install_dir       = "/usr/local"
  $newfile           = "StagingRelease/ymlValidator.php"

  file {"${kits_dir}/${source_tarball}":
    source => "puppet:///modules/manhunt/${source_tarball}",
    owner => "root", group => "root", mode => "0755", }

  manhunt::tarextract { "$build_area/KITS/$source_tarball":
    source      => "$build_area/KITS/$source_tarball",
    directory   => "$install_dir",
    newfile     => "$newfile",
    require     => File["${kits_dir}/${source_tarball}"],
  }

 case $hostname {
    admin42, www05, billing04, billing05: {
      file { "/tmp/stagerator.sh":
        ensure => absent,
      }     
    }     
    default: {
      file { "/tmp/stagerator.sh":
        source => "puppet:///modules/manhunt/tools/stagerator.sh",
    	owner => "root", group => "root", mode => "0700",}
    }
  }

  file { "/tmp/appymlizer.sh":
    source => "puppet:///modules/manhunt/tools/appymlizer.sh",
    owner => "root", group => "root", mode => "0700",}

  file { "/tmp/rollbackerator.sh":
    source => "puppet:///modules/manhunt/tools/rollbackerator.sh",
    owner => "root", group => "root", mode => "0700",}


}#end of class
