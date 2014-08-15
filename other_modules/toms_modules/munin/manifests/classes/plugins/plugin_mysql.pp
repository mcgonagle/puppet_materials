class munin::plugin::mysql inherits munin::plugin {
  package{"perl-Cache-Cache": ensure => latest }

  file {"/etc/munin/plugin-conf.d/mysql":
content => inline_template("[mysql_*]
env.mysqlconnection DBI:mysql:mysql;host=localhost;port=3306
env.mysqlopts -uroot -p''"),
    owner => "root", group => "root", mode => "0644",
    require => File["/etc/munin/plugins/mysql_bin_relay_log"],
    notify => Service["munin-node"], }

  file {"/etc/munin/plugins/mysql_bin_relay_log":
          ensure => link,
          target => "/usr/share/munin/plugins/mysql_",
          notify => Service["munin-node"],
          require => Package["munin-node"];
        "/etc/munin/plugins/mysql_commands":
          ensure => link,
          target => "/usr/share/munin/plugins/mysql_",
          notify => Service["munin-node"],
          require => Package["munin-node"];
        "/etc/munin/plugins/mysql_files_tables":
          ensure => link,
          target => "/usr/share/munin/plugins/mysql_",
          notify => Service["munin-node"],
          require => Package["munin-node"];
        "/etc/munin/plugins/mysql_innodb_bpool":
          ensure => link,
          target => "/usr/share/munin/plugins/mysql_",
          notify => Service["munin-node"],
          require => Package["munin-node"];
        "/etc/munin/plugins/mysql_innodb_bpool_act":
          ensure => link,
          target => "/usr/share/munin/plugins/mysql_",
          notify => Service["munin-node"],
          require => Package["munin-node"];
        "/etc/munin/plugins/mysql_innodb_insert_buf":
          ensure => link,
          target => "/usr/share/munin/plugins/mysql_",
          notify => Service["munin-node"],
          require => Package["munin-node"];
        "/etc/munin/plugins/mysql_innodb_io":
          ensure => link,
          target => "/usr/share/munin/plugins/mysql_",
          notify => Service["munin-node"],
          require => Package["munin-node"];
        "/etc/munin/plugins/mysql_innodb_io_pend":
          ensure => link,
          target => "/usr/share/munin/plugins/mysql_",
          notify => Service["munin-node"],
          require => Package["munin-node"];
        "/etc/munin/plugins/mysql_innodb_log":
          ensure => link,
          target => "/usr/share/munin/plugins/mysql_",
          notify => Service["munin-node"],
          require => Package["munin-node"];
        "/etc/munin/plugins/mysql_innodb_rows":
          ensure => link,
          target => "/usr/share/munin/plugins/mysql_",
          notify => Service["munin-node"],
          require => Package["munin-node"];
        "/etc/munin/plugins/mysql_innodb_semaphores":
          ensure => link,
          target => "/usr/share/munin/plugins/mysql_",
          notify => Service["munin-node"],
          require => Package["munin-node"];
        "/etc/munin/plugins/mysql_innodb_tnx":
          ensure => link,
          target => "/usr/share/munin/plugins/mysql_",
          notify => Service["munin-node"],
          require => Package["munin-node"];
        "/etc/munin/plugins/mysql_myisam_indexes":
          ensure => link,
          target => "/usr/share/munin/plugins/mysql_",
          notify => Service["munin-node"],
          require => Package["munin-node"];
        "/etc/munin/plugins/mysql_network_traffic":
          ensure => link,
          target => "/usr/share/munin/plugins/mysql_",
          notify => Service["munin-node"],
          require => Package["munin-node"];
        "/etc/munin/plugins/mysql_qcache":
          ensure => link,
          target => "/usr/share/munin/plugins/mysql_",
          notify => Service["munin-node"],
          require => Package["munin-node"];
        "/etc/munin/plugins/mysql_qcache_mem":
          ensure => link,
          target => "/usr/share/munin/plugins/mysql_",
          notify => Service["munin-node"],
          require => Package["munin-node"];
        "/etc/munin/plugins/mysql_replication":
          ensure => link,
          target => "/usr/share/munin/plugins/mysql_",
          notify => Service["munin-node"],
          require => Package["munin-node"];
        "/etc/munin/plugins/mysql_select_types":
          ensure => link,
          target => "/usr/share/munin/plugins/mysql_",
          notify => Service["munin-node"],
          require => Package["munin-node"];
        "/etc/munin/plugins/mysql_slow":
          ensure => link,
          target => "/usr/share/munin/plugins/mysql_",
          notify => Service["munin-node"],
          require => Package["munin-node"];
        "/etc/munin/plugins/mysql_sorts":
          ensure => link,
          target => "/usr/share/munin/plugins/mysql_",
          notify => Service["munin-node"],
          require => Package["munin-node"];
        "/etc/munin/plugins/mysql_table_locks":
          ensure => link,
          target => "/usr/share/munin/plugins/mysql_",
          notify => Service["munin-node"],
          require => Package["munin-node"];
        "/etc/munin/plugins/mysql_tmp_tables":
          ensure => link,
          target => "/usr/share/munin/plugins/mysql_",
          notify => Service["munin-node"],
          require => Package["munin-node"];

 }#end of file definition
}#end of class munin::plugin::mysql
