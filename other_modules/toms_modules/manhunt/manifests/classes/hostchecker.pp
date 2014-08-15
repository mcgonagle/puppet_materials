class manhunt::hostchecker inherits manhunt {
  file { "${cron_dir}/hostchecker.pl":
    source => "puppet:///modules/manhunt/tools/hostchecker.pl",
    owner => "root", group => "root", mode => "0755",
  }
}
