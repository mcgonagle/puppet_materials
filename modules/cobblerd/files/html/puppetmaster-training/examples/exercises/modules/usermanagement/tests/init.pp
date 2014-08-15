include usermanagement

usermanagement::manage_user {
  "bob":
    gid    => "one";
  "bob2":
    gid    => "one";
  "bob3":
    gid    => "one",
    ensure => absent;
  "dan":;
# uncomment and see what happens..
#  "root":
#    ensure => absent;
} # manage_user
