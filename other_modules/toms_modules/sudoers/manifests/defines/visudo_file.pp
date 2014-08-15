# sudoers/manifests/defines/visudo_file.pp
# a trivial mechanism to ensure a file is a validly parsed sudoers file
#
# Online Buddies, Inc,
#
#  Usage:
#  sudoers::visudo_file{"/etc/sudoers":
#  }
#
#
define sudoers::visudo_file () {
  # the name of the sudoers file to test
  exec{"visudo $name":
    path        => '/bin:/usr/sbin:/usr/bin',
#    logoutput   => on_failure,
    returns => 0,
    logoutput   => true,
    command      => "visudo -c -f $name",
    creates     => "$name",
  }
}
