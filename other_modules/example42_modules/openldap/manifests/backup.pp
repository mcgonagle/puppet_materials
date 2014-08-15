# Class: openldap::backup
#
# Backups openldap data and logs using Example42 backup meta module (to be adapted to custom backup solutions)
# It's automatically included and used if $backup=yes
# This class permits to abstract what you want to backup from the tool and module to use for backups.
#
# Variables:
# The behaviour of this class has some defaults that can be overriden by user's variables:
# $openldap_backup_data (true|false) : Set if you want to backup openldap's data. Default: As defined in $backup_data
# $openldap_backup_log (true|false) : Set if you want to backup openldap's logs. Default: As defined in $backup_log
# $openldap_backup_frequency (hourly|daily|weekly|monthly) : Set the frequency of your openldap backups. Default: daily.
# $openldap_backup_target : Define how to reach (Ip, fqdn...) this host to backup openldap from an external server. Default: As defined in $backup_target
# 
# You can also set some site wide variables that can be overriden by the above module specific ones:
# $backup_data (true|false) : Set if you want to enable data backups site-wide. 
# $backup_log (true|false) : Set if you want to enable logs backups site-wide. 
# $backup_target : Set the ip/hostname you want to use on an external backup server to backup this host
# For the defaults of the above variables check openldap::params
#
# Usage:
# Automatically included if $backup=yes
#
class openldap::backup {

    include openldap::params

    backup { "openldap_data": 
        frequency => "${openldap::params::backup_frequency}",
        path      => "${openldap::params::datadir}",
        enabled   => "${openldap::params::backup_data_enable}",
        target    => "${openldap::params::backup_target_real}",
    }
    
    backup { "openldap_logs": 
        frequency => "${openldap::params::backup_frequency}",
        path      => "${openldap::params::logdir}",
        enabled   => "${openldap::params::backup_log_enable}",
        target    => "${openldap::params::backup_target_real}",
    }

    # Include project specific backup class if $my_project is set
    if $my_project { 
        case $my_project_onmodule {
            yes,true: { include "${my_project}::openldap::backup" }
            default: { include "openldap::${my_project}::backup" }
        }
    }

}
