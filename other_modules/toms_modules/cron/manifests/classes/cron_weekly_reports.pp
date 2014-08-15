class cron::cron_weekly_reports inherits cron {
  include pkg_sharutils

  file { "/home/care/reports":
    ensure => directory,
    mode => 2750, owner => care, group => sysadmin,
  }

  file { "/var/www":
    ensure => directory,
    mode => 2750, owner => apache, group => apache,
  }

  file { "/var/www/manhunt":
    ensure => directory,
    mode => 2750, owner => apache, group => apache,
  }

  file { "/var/www/manhunt/htdocs":
    ensure => directory,
    mode => 2750, owner => apache, group => apache,
  }

  file { "/var/www/manhunt/htdocs/admin":
    ensure => directory,
    mode => 2750, owner => apache, group => apache,
  }

  file { "/var/www/manhunt/htdocs/admin/CLweeklyreports.sh":
    source => "puppet:///modules/cron/mh_cron_scripts/CLweeklyreports.sh",
    owner => root, group => root, mode => 755,
  }
  file { "/var/www/manhunt/htdocs/admin/CLnewadsjp.php":
    source => "puppet:///modules/cron/mh_cron_scripts/CLnewadsjp.php",
    owner => build, group => build, mode => 755,
  }
  file { "/var/www/manhunt/htdocs/admin/CLnewprofsjp.php":
    source => "puppet:///modules/cron/mh_cron_scripts/CLnewprofsjp.php",
    owner => build, group => build, mode => 755,
  }

  case $hostname {
    cron02: {
      cron { weekly_reports:
        ensure => present,
        command => "/var/www/manhunt/htdocs/admin/CLweeklyreports.sh",
        user    => care,
        minute  => '00',
        hour    => '11',
        weekday => '1',
        require => [ File [ "/etc/manhunt/source.sh" ],
                     File [ "/home/care/reports" ] ],
      }#end of cron type
    }#end of cron02
  }#end of case hostname
}
