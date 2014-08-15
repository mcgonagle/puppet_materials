class nagios::timeperiod inherits nagios {

nagios_timeperiod { "24x7":
        timeperiod_name 	=> "24x7",
        alias           	=> "24 Hours A Day, 7 Days A Week",
        sunday          	=> "00:00-24:00",
        monday          	=> "00:00-24:00",
        tuesday         	=> "00:00-24:00",
        wednesday       	=> "00:00-24:00",
        thursday        	=> "00:00-24:00",
        friday          	=> "00:00-24:00",
        saturday        	=> "00:00-24:00",
}

nagios_timeperiod { "logcheck-schedule":
        timeperiod_name 	=> "logcheck-schedule",
        alias           	=> "logcheck-schedule",
        sunday          	=> "9:30-13:00",
        monday          	=> "9:30-13:00",
        tuesday         	=> "9:30-13:00",
        wednesday       	=> "9:30-13:00",
        thursday        	=> "9:30-13:00",
        friday          	=> "9:30-13:00",
        saturday        	=> "9:30-13:00",
}

nagios_timeperiod { "never":
        timeperiod_name 	=> "never",
        alias           	=> "No Time Is A Good Time",
}

nagios_timeperiod { "nonworkhours":
        timeperiod_name 	=> "nonworkhours",
        alias           	=> "Non-Work Hours",
        sunday          	=> "00:00-24:00",
        monday          	=> "00:00-09:00,17:00-24:00",
        tuesday         	=> "00:00-09:00,17:00-24:00",
        wednesday       	=> "00:00-09:00,17:00-24:00",
        thursday        	=> "00:00-09:00,17:00-24:00",
        friday          	=> "00:00-09:00,17:00-24:00",
        saturday        	=> "00:00-24:00",
}

nagios_timeperiod { "notify14x7backup":
        timeperiod_name 	=> "notify14x7backup",
        alias           	=> "14 hours daily (outside backup window)",
        sunday          	=> "00:00-04:45,14:45-24:00",
        monday          	=> "00:00-04:45,14:45-24:00",
        tuesday         	=> "00:00-04:45,14:45-24:00",
        wednesday       	=> "00:00-04:45,14:45-24:00",
        thursday        	=> "00:00-04:45,14:45-24:00",
        friday          	=> "00:00-04:45,14:45-24:00",
        saturday        	=> "00:00-04:45,14:45-24:00",
}

nagios_timeperiod { "notify21x7backup":
        timeperiod_name 	=> "notify21x7backup",
        alias           	=> "21 hours daily (outside backup window)",
        sunday          	=> "00:00-04:45,07:15-24:00",
        monday          	=> "00:00-04:45,07:15-24:00",
        tuesday         	=> "00:00-04:45,07:15-24:00",
        wednesday       	=> "00:00-04:45,07:15-24:00",
        thursday        	=> "00:00-04:45,07:15-24:00",
        friday          	=> "00:00-04:45,07:15-24:00",
        saturday        	=> "00:00-04:45,07:15-24:00",
}

nagios_timeperiod { "notify24x7":
        timeperiod_name 	=> "notify24x7",
        alias           	=> "almost all 24 Hours A Day, 7 Days A Week",
        sunday          	=> "00:00-03:00,03:15-04:15,05:15-24:00",
        monday          	=> "00:00-03:00,03:15-04:15,05:15-24:00",
        tuesday         	=> "00:00-03:00,03:15-04:15,05:15-24:00",
        wednesday       	=> "00:00-03:00,03:15-04:15,05:15-24:00",
        thursday        	=> "00:00-03:00,03:15-04:15,05:15-24:00",
        friday          	=> "00:00-03:00,03:15-04:15,05:15-24:00",
        saturday        	=> "00:00-03:00,03:15-04:15,05:15-24:00",
}

nagios_timeperiod { "workhours":
        timeperiod_name 	=> "workhours",
        alias           	=> "Normal Working Hours",
        monday          	=> "09:00-17:00",
        tuesday         	=> "09:00-17:00",
        wednesday       	=> "09:00-17:00",
        thursday        	=> "09:00-17:00",
        friday          	=> "09:00-17:00",
}

}#end of nagios::timeperiod
