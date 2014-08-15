# sudoers/manifests/defines/sudoers_file.pp
#
# mechanism to install a sudoers file 
# dir and sudoers_conf_file are required
# files will be checked for validity before installing
#
# Online Buddies, Inc,
#
#  Usage:
#  sudoers::sudoers_file{'/etc/sudoers':
#    dir=>'/etc',
#    sudoers_conf_file=>'sudoers',
#  }
#
#  sudoers::sudoers_file{"/etc/sudoers.d/sudoers.foo":
#    dir=>'/etc/sudoers.d',
#    sudoers_conf_file=>"sudoers.foo",
#    require => [ File["/etc/sudoers.d"], Sudoers::Sudoers_File["/etc/sudoers"] ],
#  }
#
#
define sudoers::sudoers_file (
  # where the sudoers file are located
  $dir = '/etc',
  # the name of the sudoers file
  $sudoers_conf_file = 'sudoers',
  $mode = 0644, $owner = root, $group = 0
  ) {

  # name of a test-version of the sudoers file for verification
  # sudoers is pre-configured to ignore tilde-qualified backup files e.g. "foo~"
  # when one exists under an INCLUDEDIR directory
  $protosudoers="${sudoers_conf_file}~"
  
  File{ owner  => 'root', group  => 'root', mode   => '0440', }
  
  file{"$dir/$protosudoers":
    source => [ "puppet:///modules/sudoers/${sudoers_conf_file}",
                "puppet:///modules/sudoers/BLANK"
                ],
    notify => Sudoers::Visudo_file[ "$dir/$protosudoers" ],
  }
  
  sudoers::visudo_file{"$dir/$protosudoers":
    subscribe   => File["$dir/$protosudoers"],
    notify => Exec [ "cp-sudoers $name" ],
  }
  
  # copy it to the tmp location if required
  exec{ "cp-sudoers $name":
    path        => '/bin:/usr/sbin:/usr/bin',
    logoutput   => true,
    # check file validity and rather or not the copies are different
    subscribe     => Sudoers::Visudo_file[ "$dir/$protosudoers" ],
    unless      => "diff $dir/$protosudoers $dir/$sudoers_conf_file",
    # this is dirty, but cp is usually aliased to cp -i
    command     => "/bin/cp -v -f $dir/$protosudoers $dir/$sudoers_conf_file",
  }

  }
