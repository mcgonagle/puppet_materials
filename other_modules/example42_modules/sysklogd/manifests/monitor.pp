# Class: sysklogd::monitor
#
# Monitors sysklogd process/ports/service using Example42 monitor meta module (to be adapted to custom monitor solutions)
# It's automatically included ad used if $monitor=yes and is defined at least one monitoring software in $monitor_tool
# This class permits to abstract what you want to monitor from the actual tool and modules you'll use for monitoring
# and can be used to quickly deploy a new monitoring solution
#
# Variables:
# The behaviour of this class has some defaults that can be overriden by user's variables:
# $sysklogd_monitor_port (true|false) : Set if you want to monitor sysklogd's port(s). If any. Default: As defined in $monitor_port
# $sysklogd_monitor_url (true|false) : Set if you want to monitor sysklogd's url(s). If any. Default: As defined in $monitor_url
# $sysklogd_monitor_process (true|false) : Set if you want to monitor sysklogd's process. If any. Default: As defined in $monitor_process
# $sysklogd_monitor_plugin (true|false) : Set if you want to monitor sysklogd using specific monitor tool's plugin  i   s. If any. Default: As defined in $monitor_plugin
# $sysklogd_monitor_target : Define how to reach (Ip, fqdn...) the host to monitor sysklogd from an external server. Default: As defined in $monitor_target
# $sysklogd_monitor_url : Define the baseurl (http://$fqdn/...) to use for eventual sysklogd URL checks. Default: As defined in $monitor_url
# 
# You can therefore set site wide variables that can be overriden by the above module specific ones:
# $monitor_port (true|false) : Set if you want to enable port monitoring site-wide.
# $monitor_url (true|false) : Set if you want to enable url checking site-wide.
# $monitor_process (true|false) : Set if you want to enable process monitoring site-wide.
# $monitor_plugin (true|false) : Set if you want to try to use specific plugins of your monitoring tools 
# $monitor_target : Set the ip/hostname you want to use on an external monitoring server to monitor this host
# $monitor_baseurl : Set baseurl to use for eventual URL checks of services provided by this host
# For the defaults of the above variables check sysklogd::params
#
# Usage:
# Automatically included if $monitor=yes
# Use the variable $monitor_tool (can be an array) to define the monitoring software you want to use.
# To customize specific and more granular behaviours use the above variables and eventually your custom modulename::monitor::$my_project class
#
class sysklogd::monitor {

    include sysklogd::params

    # Port monitoring
    monitor::port { "sysklogd_${sysklogd::params::protocol}_${sysklogd::params::port}": 
        protocol => "${sysklogd::params::protocol}",
        port     => "${sysklogd::params::port}",
        target   => "${sysklogd::params::monitor_target_real}",
        enable   => "${sysklogd::params::monitor_port_enable}",
        tool     => "${monitor_tool}",
    }
    
    # URL monitoring 
    monitor::url { "sysklogd_url":
        url      => "${sysklogd::params::monitor_baseurl_real}/index.php",
        pattern  => "${sysklogd::params::monitor_url_pattern}",
        enable   => "${sysklogd::params::monitor_url_enable}",
        tool     => "${monitor_tool}",
    }

    # Process monitoring 
    monitor::process { "sysklogd_process":
        process  => "${sysklogd::params::processname}",
        service  => "${sysklogd::params::servicename}",
        pidfile  => "${sysklogd::params::pidfile}",
        enable   => "${sysklogd::params::monitor_process_enable}",
        tool     => "${monitor_tool}",
    }

    # Use a specific plugin (according to the monitor tool used)
    monitor::plugin { "sysklogd_plugin":
        plugin   => "sysklogd",
        enable   => "${sysklogd::params::monitor_plugin_enable}",
        tool     => "${monitor_tool}",
    }

    # Include project specific monitor class if $my_project is set
    if $my_project { 
        case $my_project_onmodule {
            yes,true: { include "${my_project}::sysklogd::monitor" }
            default: { include "sysklogd::monitor::${my_project}" }
        }
    }

}
