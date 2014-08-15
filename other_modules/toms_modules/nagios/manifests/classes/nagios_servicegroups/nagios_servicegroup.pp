class nagios::servicegroup inherits nagios {
 @@nagios_servicegroup {"default-servicegroup":
    alias => "default-servicegroup",
    members => "check_disk, check_eth0, check_eth1, check_eth2, check_eth3, check_bond0, check_bond1, check_load, check_nrpe, check_ping, check_puppet_proc, check_puppet_run, check_ssh, check_ssh, check_users, check_zombie_procs",
   }
   
} 
