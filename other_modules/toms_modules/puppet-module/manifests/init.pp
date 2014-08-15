class puppet-module {
  package { "puppet-module": 
      ensure => latest,
      provider => gem, }


}#end of puppet-module class
