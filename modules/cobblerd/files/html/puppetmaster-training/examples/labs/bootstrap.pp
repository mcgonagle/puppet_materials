define bootstrap ( $address = $ipaddress, $domainname, $server=false, $masterip ) {
  exec {"/bin/hostname ${name}.${domainname}": }
  file {'/etc/sysconfig/network':
    owner => 'root',
    group => 'root',
    mode => '644',
    content => "NETWORKING=yes\nNETWORKING_IPV6=no\nHOSTNAME=${name}.${domainname}.${ip}",
  }
  host {
    'puppet': ensure => present, ip => $masterip, alias => "puppet.${domainname}";
    $name: ensure => present, ip => $address, alias => "${name}.${domainname}"; 
  }
}
bootstrap {'pserver': server => true, domainname => 'puppetlabs.com', masterip => '172.16.238.136',}
