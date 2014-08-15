define inet::service (
  $sock_type = stream, $proto = tcp, $flags = wait,
  $user = root, $path, $args = "", $ensure
) {
  file {"${inet::basedir}/inetd.d/$name":
    content => "$name   $sock_type  $proto  $flags  $user   $path $args\n",
    notify  => Exec['rebuild-inetd'],
    ensure  => $ensure,
  }
}
