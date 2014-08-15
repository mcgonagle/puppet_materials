class tomcat::service {

   service {"tomcat": 
        enable  => false, 
        ensure  => stopped,
        hasstatus => true, 
        hasrestart => true,
        require => Class["tomcat::config"], }

}#end of class tomcat
