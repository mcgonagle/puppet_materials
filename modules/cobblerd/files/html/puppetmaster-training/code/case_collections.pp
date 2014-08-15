case $operatingsystem {
  'debian':  { include Debian } # apply the Debian class
  'ubuntu':  { include Ubuntu } # apply the Ubuntu class
   default:  { include Centos } # apply the Centos class
}
