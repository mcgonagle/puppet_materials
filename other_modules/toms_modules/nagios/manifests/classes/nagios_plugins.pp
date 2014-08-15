import "nagios_plugins/*.pp"
class nagios::plugins inherits nagios {
  package{"nagios-plugins-procs": ensure => latest }

#Nagios_service {
#       contact_groups                  => "it", 
#       is_volatile                      => '0',
#       max_check_attempts               => '3',
#       normal_check_interval            => '5',
#       retry_check_interval             => '1',
#       active_checks_enabled            => '1',
#       passive_checks_enabled           => '1',
#       parallelize_check                => '1',
#       obsess_over_service              => '1',
#       check_freshness                  => '0',
#       event_handler_enabled            => '1',
#       flap_detection_enabled           => '1',
#       process_perf_data                => '1',
#       retain_status_information        => '1',
#       retain_nonstatus_information     => '1',
#       contact_groups                   => 'it',
#       notification_interval            => '0',
#       notification_period              => 'notify24x7',
#       notification_options             => 'w,u,c,r',
#       notifications_enabled            => 1,
#       failure_prediction_enabled       => 1,
#       register                         => 1, }
#
}#end of nagios::plugins class
