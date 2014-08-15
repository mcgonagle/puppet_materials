define cron::manhunt_cron_test ( $status="OK",   $ensure = present ) {
  include cron_tester_script
  
  $status_to_test = $status ? {
    OK => 0,
    WARNING => 1,
    CRITICAL => 2,
    UNKNOWN => 3,
  }
  cron { "cron_tester.sh":
    command => "$cron_dir/cron_tester.sh $status_to_test",
    user   => care,
    minute => '*/5',
    ensure => $ensure,
  }
}
