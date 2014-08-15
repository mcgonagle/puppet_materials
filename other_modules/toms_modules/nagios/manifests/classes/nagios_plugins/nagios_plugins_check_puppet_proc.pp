class nagios::plugins::check_puppet_proc inherits nagios::plugins {


#nagios_command {"check_puppet_proc":
#       command_line    => '$USER1$/check_procs -C $USER4$',
#       require => Package["nagios-plugins-procs"], }     

@@nagios_service {"check_puppet_proc":
       host_name                       => "${hostname}",
       service_description             => "CHECK_PUPPET_PROC",
       check_command                   => "check_nrpe!check_puppet_proc",
       check_period                    => "24x7",
       contact_groups                  => "it", 
       #require                         => Nagios_command["check_puppet_proc"],}
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

}
