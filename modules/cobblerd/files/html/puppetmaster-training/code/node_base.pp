node base {
  include ssh
  include puppet
  include security
}
node 'foo.puppetlabs.com', 'bar.puppetlabs.com' inherits base {
  include redmine, wordpress
}

