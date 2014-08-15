import "classes/*.pp"
class mysqlmonitor {
 $mysql_root_password = extlookup("mysql_root_password")
 $agent_mgmt_hostname = extlookup("agent_mgmt_hostname")
 $agent_mgmt_username = extlookup("agent_mgmt_username")
 $agent_mgmt_password = extlookup("agent_mgmt_password")
 $agent_query_analyzer = extlookup("agent_query_analyzer")


 #installs the mysqlmonitoragent client via rpm
 package { "mysqlmonitoragent": ensure => latest }

 file {"/opt/mysql/enterprise/agent/etc/mysql-monitor-agent.ini":
	content => template("mysqlmonitor/mysql-monitor-agent.ini.erb"),
	owner => "root", group => "root", mode => "0600",
	notify => Service["mysql-monitor-agent"], }

 file {"/opt/mysql/enterprise/agent/etc/instances/mysql/agent-instance.ini":
	content => template("mysqlmonitor/agent-instance.ini.erb"),
	owner => "root", group => "root", mode => "0600",
        notify => Service["mysql-monitor-agent"], }

 service { "mysql-monitor-agent":
  enable => true,
  ensure => running,
 }


}#end of class mysqlmonitor
