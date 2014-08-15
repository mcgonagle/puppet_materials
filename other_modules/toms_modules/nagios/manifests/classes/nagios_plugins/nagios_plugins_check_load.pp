class nagios::plugins::check_load inherits nagios::plugins {

#nagios_command {"check_load":
#       command_line    => '$USER1$/check_procs -w $ARG1$ -c $ARG2$',
#       require => Package["nagios-plugins-procs"], }     

@@nagios_service {"check_load":
       host_name                       => "${hostname}",
       service_description             => "LOAD",
       check_command                   => "check_nrpe!check_load",
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
       #require                         => Nagios_command["check_load"],}

}#end of nagios::plugins::check_load
