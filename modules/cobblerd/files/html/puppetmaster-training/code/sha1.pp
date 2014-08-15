$user = 'elvis'
$tmp_passwd = sha1("${uniqueid}${hostname}${user}")
user {$user:
  ensure   => present,
  password => $tmp_passwd,
}
notice("Elvis's password is ${tmp_passwd}")
