class webserver {

  include stages
  class { 'yum': stage => before }
  include packages   #Same as class { 'packages': }
  class { 'apache': stage => after }

}
