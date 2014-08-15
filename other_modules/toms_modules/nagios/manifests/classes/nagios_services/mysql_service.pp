class nagios::service inherits nagios {
 Nagios_service {
        ##hostgroup_name                 => "billing_servers",
        ##service_description            => "CHECKFILES",
        is_volatile                     => "0",
        ##check_command                  => "check_nrpe!check_file_age",
        max_check_attempts              => "3",
        normal_check_interval           => "5",
        retry_check_interval            => "1",
        active_checks_enabled           => "1",
        passive_checks_enabled          => "1",
        ##check_period                   => "logcheck-schedule",
        parallelize_check               => "1",
        obsess_over_service             => "1",
        check_freshness                 => "0",
        ##event_handler                  => "host-notify-by-email",
        event_handler_enabled           => "1",
        flap_detection_enabled          => "1",
        process_perf_data               => "1",
        retain_status_information       => "1",
        retain_nonstatus_information    => "1",
        ##contact_groups                 => "it",
        notification_interval           => "0",
        notification_period             => "notify24x7",
        notification_options            => "w,u,c,r",
        notifications_enabled           => "1",
        failure_prediction_enabled      => "1",
        register                	      => "1",
	      require		=> [ File["/etc/nagios/nrpe"], Package["nrpe"]], }


 nagios_service {"nagios_service mysql,mysqlrepbackup":
        hostgroup_name                  => "mysql,mysqlrepbackup",
        service_description             => "CONNECTIONS",
        check_command                   => "check_mysql_cxns",
        check_period                    => "24x7",
        contact_groups                  => "database,it",}

 nagios_service {"nagios_service mysql,mysqlrepbackup":
        hostgroup_name                  => "mysql,mysqlrepbackup",
        service_description             => "DBLOAD",
        check_command                   => "check_nrpe!check_load_db",
        check_period                    => "24x7",
        contact_groups                  => "database,it",}


 nagios_service {"nagios_service drbdprimary":
        hostgroup_name                  => "drbdprimary",
        service_description             => "DRBD_PRIM",
        check_command                   => "check_nrpe!check_drbd_primary",
        check_period                    => "24x7",
        event_handler                   => "host-notify-by-email",
        contact_groups                  => "it",}

 nagios_service {"nagios_service drbdsecondary":
        hostgroup_name                  => "drbdsecondary",
        service_description             => "DRBD_SEC",
        check_command                   => "check_nrpe!check_drbd_secondary",
        check_period                    => "24x7",
        event_handler                   => "host-notify-by-email",
        contact_groups                  => "it",}


 nagios_service {"nagios_service maindb02":
        host_name    	                => "maindb02",
        service_description             => "EXACTTARGET_FILE_CHECK",
	normal_check			=> "180",
	retry_check_interval		=> "180",
        check_command                   => "check_nrpe!check_exacttarget_file",
        check_period                    => "24x7",
        contact_groups                  => "it",}


 nagios_service {"nagios_service mysql_innodb":
        hostgroup_name                  => "mysql_innodb",
        service_description             => "INNODB FREE",
        check_command                   => "check_innodb_free",
        check_period                    => "24x7",
        contact_groups                  => "database,it",}


 nagios_service {"nagios_service jpdb01, jpdb02, jpmaildb01, jpmaildb02":
	host_name			=> "jpdb01,jpdb02, jpmaildb01, jpmaildb02",
        service_description             => "INNODB FREE JP",
        check_command                   => "check_innodb_free_jp",
        check_period                    => "24x7",
        contact_groups                  => "database, it",}


 nagios_service {"nagios_service innodb_util":
        hostgroup_name                  => "innodb_util",
        service_description             => "INNODB UTILIZATION",
        check_command                   => "check_innodb_utilization",
        check_period                    => "24x7",
        contact_groups                  => "it,itdebug",}


 nagios_service {"nagios_service mysql,mysqlrepbackup":
        hostgroup_name                  => "mysql,mysqlrepbackup",
        service_description             => "MYSQL",
        check_command                   => "check_mysql",
        check_period                    => "24x7",
        contact_groups                  => "database, it",}


 nagios_service {"nagios_service openx_db_services":
        hostgroup_name                  => "openx_db_services", 
        service_description             => "OX_SHADOW_COUNT",
        check_command                   => "check_openx_count!0.06!0.07!openx",
        check_period                    => "24x7",
        contact_groups                  => "database",}

 nagios_service {"nagios_service openxdb01":
        hostgroup_name                  => "openxdb01", 
        service_description             => "OX_SHADOW_EVT",
        check_command                   => "check_openxshadow_evt!60!120!openx",
        check_period                    => "24x7",
        contact_groups                  => "database",}


 nagios_service {"nagios_service network,phy-server,virtual":
        hostgroup_name                  => "network,phy-server,virtual", 
        service_description             => "PING",
        check_command                   => "check_ping",
        check_period                    => "24x7",
        contact_groups                  => "it",}

 nagios_service {"nagios_service maindb00":
        hostgroup_name                  => "maindb00", 
        service_description             => "PRUNE_BLOCKS_BUDDIES_EVT", 
        check_command                   => "check_prune_evt!last_executed!mysql.event!evt_bud_blk_pruner!graveyard",
        normal_check_interval           => "120",
        check_period                    => "24x7",
        contact_groups                  => "database",
        notification_period             => "workhours", }

 nagios_service {"nagios_service mailshard_events":
        hostgroup_name                  => "mailshard_events", 
        service_description             => "PRUNE_MAIL_EVT", 
        check_command                   => "check_prune_evt!graveyardAddDate!mysql_prune_evt_log!mail_pruner!manhunt_mail_v4",
        normal_check_interval           => "120",
        check_period                    => "24x7",
        contact_groups                  => "database",
        notification_period             => "workhours", }

 nagios_service {"nagios_service maindb00":
        host_name                  	=> "maindb00", 
        service_description             => "PRUNE_UNLOCKS_EVT", 
        check_command                   => "check_prune_evt!last_executed!mysql.event!evt_PurgeOldUnlocks!graveyard",
        normal_check_interval           => "120",
        check_period                    => "24x7",
        contact_groups                  => "database",
        notification_period             => "workhours", }

 nagios_service {"nagios_service mysqlrep":
        hostgroup_name                  => "mysqlrep", 
        service_description             => "MYSQL REP LAG",
        check_command                   => "check_rep_lag",
        check_period                    => "24x7",
        contact_groups                  => "database,it",}


 nagios_service {"nagios_service mysqlrepbackup":
        hostgroup_name                  => "mysqlrepbackup", 
        service_description             => "MYSQL REP LAG BKP",
        check_command                   => "check_rep_lag",
        check_period                    => "24x7",
        contact_groups                  => "database,it",}

 nagios_service {"nagios_service mysqlrepbackuplong":
        hostgroup_name                  => "mysqlrepbackuplong", 
        service_description             => "MYSQL REP LAG BKPLONG",
        check_command                   => "check_rep_lag",
        check_period                    => "notify14x7backup",
        contact_groups                  => "database,it",
	notification_period		=> "notify14x7backup",}

 nagios_service {"nagios_service mysqlrep":
        hostgroup_name                  => "mysqlrep", 
        service_description             => "REPLICATION",
        check_command                   => "check_mysql_rep",
        check_period                    => "24x7",
        contact_groups                  => "database,it",}

 
 nagios_service {"nagios_service mysqlrepbackup":
        hostgroup_name                  => "mysqlrepbackup", 
        service_description             => "REPLICATION BKP",
        check_command                   => "check_mysql_rep",
        check_period                    => "notify21x7backup",
        check_period                    => "24x7",
        contact_groups                  => "database,it",
	notification_period		=> "notify14x7backup",}


}#end of nagios::service class
