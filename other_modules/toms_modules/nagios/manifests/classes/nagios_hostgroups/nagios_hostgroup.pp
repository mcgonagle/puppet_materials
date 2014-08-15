class nagios::hostgroup inherits nagios {

nagios_hostgroup { "apache":
        hostgroup_name          => "apache",
        alias                   => "Web Servers",
        #members                => "japan01,japan02,mhads02,mhads03,mhads04,mhads05,mhads06,mhads07,mhads08,www01,www02,www03,www04,www05,www06,www07,www08,www09,www10,www11,www12,www13,www14,www15,www16,www17,www18,www19,www20,www21,www22,www23,www24,www25,www26", 
}

nagios_hostgroup { "apachesecure":
        hostgroup_name          => "apachesecure",
        alias                   => "Secure Web Servers",
        #members                => "japan01,japan02,lbf5-01,lbf5-02,myna,openxadm01,starling",
}

nagios_hostgroup { "billing_servers":
        hostgroup_name          => "billing_servers",
        alias                   => "Daily Download Servers",
        #members                 => "billing02",
}

nagios_hostgroup { "critical":
        hostgroup_name          => "critical",
        alias                   => "Critical Servers",
        #members                => "cock,dick,idns04,idns05,itdb04,itdb06,japan01,japan02,jpdb01,jpdb02,jpmaildb01,jpmaildb02,mgate01,mgate02,myna,pix,router1,router2,smtp01,smtp02,starling,sw-21-red-a,sw-22-blue-a,tera-bactyl02,wdns01,www01,www02,www03,www04,www05,www06,www07,www08,www09,www10,www11,www13,www14,www15,www16,www17,www18,www19,www20,www21,www22",
}

nagios_hostgroup { "dhcp":
        hostgroup_name          => "dhcp",
        alias                   => "DHCP servers",
        members                 => "myna,starling",
}

nagios_hostgroup { "dns":
        hostgroup_name          => "dns",
        alias                   => "DNS servers",
        #members                => "idns04,idns05",
}

nagios_hostgroup { "dontbugme":
        hostgroup_name          => "dontbugme",
        alias                   => "No alerts from this group",
        #members                 => "dick",
}

nagios_hostgroup { "drbdprimary":
        hostgroup_name          => "drbdprimary",
        alias                   => "DRBD servers",
        members                 => "mail01,mail02,mail03,mail04,maindb01",
}

nagios_hostgroup { "drbdsecondary":
        hostgroup_name          => "drbdsecondary",
        alias                   => "DRBD secondaries",
        #members                => "maildb05,maildb06,maildb07,maildb08,maindb02",
}

nagios_hostgroup { "edns":
        hostgroup_name          => "edns",
        alias                   => "External DNS servers",
        #members                => "edns01,edns02",
}

nagios_hostgroup { "innodb_util":
        hostgroup_name          => "innodb_util",
        alias                   => "V4 host grp to monitor innodb space util -- requires /etc/init.d/mysql* file to point to a basedir/mysql.sock",
        members                 => "admindb01,admindb02,maindb00,stg-mailshard01,stg-mailshard02,stg-mailshard03,stg-mailshard04",
}

nagios_hostgroup { "instantlinux":
        hostgroup_name          => "instantlinux",
        alias                   => "Managed by puppet",
        #members                => "admin02,admin41,admin42,admindb02,billing01,billing02,billing03,billing04,billing05,billing09,cache03,cache04,cache05,cache06,cache07,db-bactyl01,db-bactyl02,dbads01,dw03,edns01,edns02,gallery04,itdb04,itdb06,japan01,logviewer01,mail01,mail02,mail03,mail04,maildb05,maildb06,maildb07,maildb08,maildb09,maindb01,maindb02,maindb03,mainro01,mainro02,mainro03,mainro06,mainro07,mainro08,mainro09,mainro10,media04,mgate01,mgate02,mhads01,mhads02,mhads03,mhads04,mhads05,mhads06,myna,openxadm01,sawmill,smartfox01,smartfox02,smartfox03,smtp01,smtp02,smtp03,smtp04,smtplv01,smtplv02,starling,tera-bactyl02,tera-bactyl03,trackdb01,wdns01,wdns02,www01,www02,www03,www04,www05,www06,www07,www08,www09,www10,www11,www13,www14,www15,www16,www17,www18,www19,www20,www21,www22",
}

nagios_hostgroup { "mailshard_events":
        hostgroup_name          => "mailshard_events",
        alias                   => "representative mailshard servers",
        #members                => "bkp-mailshard01,bkp-mailshard02,bkp-mailshard03,bkp-mailshard04",
} 

nagios_hostgroup { "media":
        hostgroup_name          => "media",
        alias                   => "V4 media server",
        #members                => "media09",
}

nagios_hostgroup { "mysql":
        hostgroup_name          => "mysql",
        alias                   => "MySQL Servers",
        #members                => "admindb01,admindb02,bkp-openxdb01,dbadsro01,dbadsro02,dw03,dwpres,itdb04,itdb06,jpdb01,jpdb02,jpmaildb01,jpmaildb02,mailshard01,mailshard01b,mailshard02,mailshard02b,mailshard03,mailshard03b,mailshard04,mailshard04b,maindb00,maindb03,mainro01,mainro02,mainro06,mainro07,mainro08,mainro09,mainro10,migrate,openxdb01,openxdb02,stg-mailshard01,stg-mailshard02,stg-mailshard03,stg-mailshard04",
}

nagios_hostgroup { "mysqlfaulty":
        hostgroup_name          => "mysqlfaulty",
        alias                   => "MySQL Faulty - Performance",
        #members                 => "migrate",
}

nagios_hostgroup { "mysqlmessages":
        hostgroup_name          => "mysqlmessages",
        alias                   => "MySQL Servers",
        #members                 => "mailshard01,mailshard02,mailshard03,mailshard04,stg-mailshard01,stg-mailshard02,stg-mailshard03,stg-mailshard04",
}

nagios_hostgroup { "mysqlrep":
        hostgroup_name          => "mysqlrep",
        alias                   => "MySQL Slave Servers",
        #members                 => "admindb01,admindb02,bkp-jpdb,bkp-jpmail,bkp-openxdb01,dbadsro01,dbadsro02,dw03,itdb04,mailshard01b,mailshard02b,mailshard03b,mailshard04b,mainro01,mainro02,mainro06,mainro07,mainro08,mainro09,mainro10,openxdb02",
}   

nagios_hostgroup { "mysqlrepbackup":
        hostgroup_name          => "mysqlrepbackup",
        alias                   => "MySQL Slave Backup",
        #members                 => "bkp-trackdb00,mailshard01,mailshard02,mailshard03,mailshard04,migrate",
}

nagios_hostgroup { "mysqlrepbkplong":
        hostgroup_name          => "mysqlrepbkplong",
        alias                   => "Backup that takes 8+ hours",
        #members                => "bkp-mailshard01,bkp-mailshard02,bkp-mailshard03,bkp-mailshard04",
}

nagios_hostgroup { "mysql_innodb":
        hostgroup_name          => "mysql_innodb",
        alias                   => "MySQL Servers with InnoDB",
        #members                => "admindb01,admindb02,bkp-openxdb01,dbadsro01,dbadsro02,dw03,dwpres,itdb04,itdb06,mailshard01,mailshard01b,mailshard02,mailshard02b,mailshard03,mailshard03b,mailshard04,mailshard04b,maindb00,maindb03,mainro01,mainro02,mainro06,mainro07,mainro08,mainro09,mainro10,migrate,openxdb01,openxdb02,stg-mailshard01,stg-mailshard02,stg-mailshard03,stg-mailshard04",
}

nagios_hostgroup { "network":
        hostgroup_name          => "network",
        alias                   => "Network routers/switches",
        #members                 => "kvm1,kvm2,kvm3,lb-int01,lb-int02,lbf5-01,lbf5-02,pix,router1,router2,sw-15-blue-a,sw-15-red-a,sw-16-purple-a,sw-16-yellow-a,sw-17-orange-a,sw-17-red-a,sw-18-blue-a,sw-20-blue-a,sw-21-red-a,sw-22-blue-a,sw-22-red-a",
}

nagios_hostgroup { "nfsservers":
        hostgroup_name          => "nfsservers",
        alias                   => "NFS Servers",
        #members                 => "isilon01,isilon02,isilon03",
}

nagios_hostgroup { "noncritical":
        hostgroup_name          => "noncritical",
        alias                   => "Noncritical, Important Servers",
        #members                 => "sawmill",
}

nagios_hostgroup { "ntpdservers":
        hostgroup_name          => "ntpdservers",
        alias                   => "NTPD Servers",
        #members                 => "cock,dick",
}

nagios_hostgroup { "openx_db_services":
        hostgroup_name          => "openx_db_services",
        alias                   => "Monitor specific OpenX activity",
        members                 => "dbadsro01,dbadsro02",
}

nagios_hostgroup { "phy-server":
        hostgroup_name          => "phy-server",
        alias                   => "All Physical Servers",
        #members                 => "admin02,admin41,admin42,admindb01,admindb02,billing01,billing02,billing03,cache02,cache06,cache07,db-bactyl01,db-bactyl02,dbads01,dbads02,dw03,edns01,ids01,itdb04,itdb06,japan01,japan02,jpdb01,jpdb02,kerberos01,kerberos02,logviewer01,mail01,mail02,mail03,mail04,maildb05,maildb06,maildb07,maildb08,maildb09,maindb01,maindb02,maindb03,mainro01,mainro02,mainro03,mainro06,mainro07,mainro08,mainro09,mainro10,media04,mgate01,mgate02,mhads01,mhads02,mhads03,mhads04,mhads05,mhads06,mhads07,mhads08,myna,openxadm01,ovulator02,sawmill,smartfox01,smartfox02,smartfox03,smtp01,smtp02,smtp03,starling,tera-bactyl02,tera-bactyl03,trackdb01,wdns01,www01,www02,www03,www04,www05,www06,www07,www08,www09,www10,www11,www12,www13,www14,www15,www16,www17,www18,www19,www20,www21,www22,www23,www24,www25,www26",
}

nagios_hostgroup { "smtp":
        hostgroup_name          => "smtp",
        alias                   => "SMTP Smart Relay Servers",
        #members                 => "smtp01,smtp02,smtp03,smtp04,smtplv01,smtplv02",
}

nagios_hostgroup { "ssh6666":
        hostgroup_name          => "ssh6666",
        alias                   => "Servers with SSH on port 6666",
        members                 => "mgate01,mgate02",
}       

nagios_hostgroup { "virtual":
        hostgroup_name          => "virtual",
        alias                   => "Virtual (VMware) Servers",
        #members                 => "billing04,billing05,billing09,cache03,cache04,cache05,edns02,gallery04,openxadm02,smtp04,smtplv01,smtplv02,wdns02",
}


}
