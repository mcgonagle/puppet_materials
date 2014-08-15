class puppet-rundeck {
 package{"rubygem-builder": ensure => latest }
 package{"puppet-rundeck": ensure => latest, provider => gem, require => Package["rubygem-builder"], }
}#end of puppet-rundeck
