class nagios::hostgroup::server inherits nagios {

  nagios_hostgroup { "server":
        hostgroup_name          => "server",
        members                 => "server",
        alias                   => "Base Server to Monitor",
        register                => 0,
  }

}
