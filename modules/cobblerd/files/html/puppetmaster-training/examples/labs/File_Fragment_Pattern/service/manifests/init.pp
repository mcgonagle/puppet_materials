# Class: service
#
# This module manages your services(5) file using file fragments
#
class service {

  # directory where file fragment directory will be placed
  $basedir = "/tmp"

  file {
    "${service::basedir}/service.d": 
      ensure  => directory,  
      purge   => true, 
      recurse => true;
    "${service::basedir}/service.d/00-service-base":
      source  => "puppet:///modules/service/00-service-base";
    "${service::basedir}/service.conf":
      mode    => 644,
      require => Exec[rebuild-service];
  } # file

  exec { "rebuild-service":
    command     => "/bin/cat ${service::basedir}/service.d/* > ${service::basedir}/service.conf",
    refreshonly => true,
    subscribe   => File["${service::basedir}/service.d"],
  } # exec

  # Definition: service::port
  # 
  #   add service to services file
  # 
  # Parameters:   
  #   $tcp     - use the tcp protocol, defaults to true
  #   $udp     - use the udp protocol, defaults to true
  #   $port    - port number
  #   $comment - comment on service
  # 
  # Actions:
  #   creates the file fragment for a service in ${service::basedir}
  #   and compiles the fragments
  # 
  # Requires:
  #   $port must be specified
  # 
  # Sample Usage:
  #   # add mytcpservice to services(5) file
  #   service::port { "mytcpservice":
  #     port => 2532,
  #     udp  => false;
  #   } # service::port
  #
  define port($tcp = true, $udp = true, $comment ="", $port) {

    File{notify => Exec["rebuild-service"]}
 
    if $tcp == true {		
      file { "${service::basedir}/service.d/${port}-${name}-tcp":
        content => "$name  ${port}/tcp  $comment \n",
      }	# file
    } # fi
 
    if $udp == true {		
      file { "${service::basedir}/service.d/${port}-${name}-udp":
        content => "$name   ${port}/udp  $comment \n",
      } # file
    } # fi
  } # define
} # class service
