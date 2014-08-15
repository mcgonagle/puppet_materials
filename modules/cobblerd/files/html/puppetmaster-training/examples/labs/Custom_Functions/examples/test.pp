$mastername = mastername()
$passwd = mycrypt(${mastername}${hostname})
$echo = echo("Setting password for $hostname to ${mastername}${hostname}. Hashed value = $passwd")
notice($echo)
