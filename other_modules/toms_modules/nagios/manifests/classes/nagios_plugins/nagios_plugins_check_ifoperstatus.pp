class nagios::plugins::ifoperstatus inherits nagios::plugins {

package { "nagios-plugins-ifoperstatus": ensure => latest }   
  
@@nagios_command { 'check_ethernet':
    command_line    => '$USER1$/check_ifoperstatus -d $ARG1$ -H $HOSTADDRESS$',
    require => Package["nagios-plugins-ifoperstatus"], }  

@@nagios_service {"check_eth0":
        host_name                       => "${hostname}",
        service_description             => "ETH0",
        check_command                   => "check_ethernet!eth0",
        check_period                    => "24x7",
        contact_groups                  => "it",
       is_volatile                      => '0',
       max_check_attempts               => '3',
       normal_check_interval            => '5',
       retry_check_interval             => '1',
       active_checks_enabled            => '1',
       passive_checks_enabled           => '1',
       parallelize_check                => '1',
       obsess_over_service              => '1',
       check_freshness                  => '0',
       event_handler_enabled            => '1',
       flap_detection_enabled           => '1',
       process_perf_data                => '1',
       retain_status_information        => '1',
       retain_nonstatus_information     => '1',
       notification_interval            => '0',
       notification_period              => 'notify24x7',
       notification_options             => 'w,u,c,r',
       notifications_enabled            => 1,
       failure_prediction_enabled       => 1,
       register                         => 1, }

@@nagios_service {"check_eth1":
        host_name                       => "${hostname}",
        service_description             => "ETH1",
        check_command                   => "check_ethernet!eth1",
        check_period                    => "24x7",
        contact_groups                  => "it",} 

@@nagios_service {"check_eth2":
        host_name                       => "${hostname}",
        service_description             => "ETH2",
        check_command                   => "check_ethernet!eth2",
        check_period                    => "24x7",
        contact_groups                  => "it",} 

@@nagios_service {"check_eth3":
        host_name                       => "${hostname}",
        service_description             => "ETH3",
        check_command                   => "check_ethernet!eth3",
        check_period                    => "24x7",
        contact_groups                  => "it",} 

@@nagios_service {"check_bond0":
        host_name                       => "${hostname}",
        service_description             => "BOND0",
        check_command                   => "check_ethernet!bond0",
        check_period                    => "24x7",
        contact_groups                  => "it",} 

@@nagios_service {"check_bond1":
        host_name                       => "${hostname}",
        service_description             => "BOND1",
        check_command                   => "check_ethernet!bond1",
        check_period                    => "24x7",
        contact_groups                  => "it",} 

}#end of nagios::plugins::ifoperstatus
