class nagios::command inherits nagios {

nagios_command { 'check-host-alive':
        command_line    => '/usr/bin/sudo /bin/ping -n -U -w 10 -c 5 $HOSTADDRESS$', }         
              
nagios_command { 'check_ping':
        command_line    => '/usr/lib64/nagios/plugins/check_ping -H $HOSTADDRESS$ -w 3000.0,80% -c 5000.0,100% -p 5', 
        require => Package["nagios-plugins-ping"], }

nagios_command { 'check_http':
        command_line    => '/usr/lib64/nagios/plugins/check_http -H $HOSTADDRESS$', 
        require => Package["nagios-plugins-http"], }

nagios_command { 'check_memcached_instance':
        command_line => '/usr/lib64/nagios/plugins/check_tcp -H $HOSTADDRESS$ -p $ARG1$ -E -s "version\\n" -e "VERSION" -w2 -c5',
        require => Package["nagios-plugins-http"], }

nagios_command { 'check_https':
        command_line    => '/usr/lib64/nagios/plugins/check_http -S -H $HOSTADDRESS$', 
        require => Package["nagios-plugins-http"], }     

nagios_command { 'check_url':
        command_line    => '/usr/lib64/nagios/plugins/check_http -H $HOSTADDRESS$ -u $ARG1$', 
        require => Package["nagios-plugins-http"], }

nagios_command { 'check_nrpe':
        command_line    => '/usr/lib64/nagios/plugins/check_nrpe -H $HOSTADDRESS$ -c $ARG1$', 
        require => Package["nagios-plugins-nrpe"], }

nagios_command { 'check_ssh':
        command_line    => '/usr/lib64/nagios/plugins/check_ssh $HOSTADDRESS$',
        require => Package["nagios-plugins-ssh"], }

nagios_command {"notify-by-email":
  command_line => '/usr/bin/printf "%b" "***** Nagios 2.12 *****\n\nNotification Type: $NOTIFICATIONTYPE$\n\nService: $SERVICEDESC$\nHost: $HOSTALIAS$\nAddress: $HOSTADDRESS$\nState: $SERVICESTATE$\n\nDate/Time: $LONGDATETIME$\n\nAdditional Info:\n\n$SERVICEOUTPUT$" | /bin/mail -s "** $NOTIFICATIONTYPE$ alert - $HOSTALIAS$/$SERVICEDESC$ is $SERVICESTATE$ **" $CONTACTEMAIL$',
  }

nagios_command {"host-notify-by-email":
  command_line => '/usr/bin/printf "%b" "***** Nagios 2.12 *****\n\nNotification Type: $NOTIFICATIONTYPE$\nHost: $HOSTNAME$\nState: $HOSTSTATE$\nAddress: $HOSTADDRESS$\nInfo: $HOSTOUTPUT$\n\nDate/Time: $LONGDATETIME$\n" | /bin/mail -s "Host $HOSTSTATE$ alert for $HOSTNAME$!" $CONTACTEMAIL$',
  }

}#end of nagios_command
