class pear::pdo inherits pear {
   include gcc
   package{"php-pdo": 
      ensure => present,
      require => Package["gcc"], }
      
}#end of class pear::pdo
