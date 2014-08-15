class nagios::contact inherits nagios {
 Nagios_contact {
        host_notification_period        => "notify24x7",
        service_notification_period     => "notify24x7",
        host_notification_options       => "d,u,r",
        service_notification_options    => "w,u,c,r",
        host_notification_commands      => "host-notify-by-email",
        service_notification_commands   => "notify-by-email", }
 
 nagios_contact {"Nagios Contact tmcgonagle":
        contact_name 			=>  "tmcgonagle",
        alias                           =>  "Thomas A. McGonagle",
        email                           =>  "tmcgonagle@online-buddies.com", }

 nagios_contact {"Nagios Contact wflynn":
        contact_name 			=>  "wflynn",
        alias                           =>  "William Flynn",
        email                           =>  "wflynn@online-buddies.com", }

 nagios_contact {"Nagios Contact dcote":
        contact_name 			=>  "dcote",
        alias                           =>  "Don Cote",
        email                           =>  "dcote@online-buddies.com", }

 nagios_contact {"Nagios Contact apradhan":
        contact_name 			=>  "apradhan",
        alias                           =>  "Akshat Pradhan",
        email                           =>  "apradhan@online-buddies.com", }

 nagios_contact {"Nagios Contact oncall phone":
        contact_name 			=>  "oncall",
        alias                           =>  "IT Oncall Phone",
        email                           =>  "6177974494@vtext.com", }

}#end of nagios::contact
