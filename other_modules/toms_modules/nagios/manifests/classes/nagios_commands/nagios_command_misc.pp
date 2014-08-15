class nagios::command::misc inherits nagios {

nagios_command { "host-notify-by-email":
        command_line    => '/usr/bin/printf "%b" "$HOSTNAME$ is $HOSTSTATE$ at $HOSTADDRESS$nnNotification Type: $NOTIFICATIONTYPE$nnDate/Time: $SHORTDATETIME$nnAdditional Info:nn$HOSTOUTPUT$" | /bin/mail -s "$NOTIFICATIONTYPE$ alert - $HOSTNAME$ is $HOSTSTATE$" $CONTACTEMAIL$',
}

nagios_command { "notify-by-email":
        command_line    => '/usr/bin/printf "%b" "@$SHORTDATETIME$ - $SERVICEOUTPUT$" | /bin/mail -s "$NOTIFICATIONTYPE$ - $HOSTNAME$/$SERVICEDESC$ $SERVICESTATE$" $CONTACTEMAIL$',
}

nagios_command { "process-host-perfdata":
        command_line    => '/usr/bin/printf "%b" "$LASTCHECK$t$HOSTNAME$t$HOSTSTATE$t$HOSTATTEMPT$t$STATETYPE$t$EXECUTIONTIME$t$OUTPUT$t$PERFDATA$" >> /var/log/nagios/host-perfdata.out',
}

nagios_command { "process-service-perfdata":
        command_line    => '/usr/bin/printf "%b" "$LASTCHECK$t$HOSTNAME$t$SERVICEDESC$t$SERVICESTATE$t$SERVICEATTEMPT$t$STATETYPE$t$EXECUTIONTIME$t$LATENCY$t$OUTPUT$t$PERFDATA$" >> /var/log/nagios/service-perfdata.out',
}

}#end of nagios::command::misc
