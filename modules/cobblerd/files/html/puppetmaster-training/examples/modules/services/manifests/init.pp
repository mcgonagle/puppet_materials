class service {
  $basedir = '/tmp'
  file { "${service::basedir}/service.d": ensure => directory,  purge => true, recurse => true }
  exec { "rebuild-service":
    command => "/bin/cat ${service::basedir}/service.d/* > ${service::basedir}/service.conf",
    refreshonly => true,
    subscribe => File["${service::basedir}/service.d"]
  }
  # Simple management on the file itself.
  file { "${service::basedir}/service.conf":  mode => 644, require => Exec[rebuild-service] }
  define port($tcp = true, $udp = true, $comment ='', $port) {
    if $tcp == true {		
      file { "${service::basedir}/service.d/${name}-tcp":
        ensure => file,
        content => "$name  ${port}/tcp  $comment ",
        notify => Exec["rebuild-service"],
      }	
    }
    if $udp == true {		
      file { "${service::basedir}/service.d/${name}-udp":
        ensure => file,
        content => "$name   ${port}/udp  $comment ",
        notify => Exec['rebuild-service'],
      }
    }
  }
}

include service
service::port {'talk':
  port => 253,
}
