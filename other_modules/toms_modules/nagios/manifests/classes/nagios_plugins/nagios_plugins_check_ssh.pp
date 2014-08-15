class nagios::plugins::check_ssh inherits nagios::plugins {
package{"nagios-plugins-ssh": ensure => latest }

@@nagios_command { 'check_ssh':
     command_line    => '$USER1$/check_ssh $HOSTADDRESS$',
     require => Package["nagios-plugins-ssh"], }   
       
@@nagios_service {"check_ssh":
     host_name                       => "${hostname}",
     service_description             => "CHECK_SSH",
     check_command                   => "check_ssh",
     check_period                    => "24x7",
     contact_groups                  => "it",
     require                         => Nagios_command["check_ssh"],
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



}#end of nagios::plugins::check_ssh
