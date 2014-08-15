# Class: rsync::backup
#
# Backups rsync data and logs using Example42 backup meta module (to be adapted to custom backup solutions)
# It's automatically included and used if $backup=yes
# This class permits to abstract what you want to backup from the tool and module to use for backups.
#
# Variables:
# The behaviour of this class has some defaults that can be overriden by user's variables:
# $rsync_backup_data (true|false) : Set if you want to backup rsync's data. Default: As defined in $backup_data
# $rsync_backup_log (true|false) : Set if you want to backup rsync's logs. Default: As defined in $backup_log
# $rsync_backup_frequency (hourly|daily|weekly|monthly) : Set the frequency of your rsync backups. Default: daily.
# $rsync_backup_target : Define how to reach (Ip, fqdn...) this host to backup rsync from an external server. Default: As defined in $backup_target
# 
# You can also set some site wide variables that can be overriden by the above module specific ones:
# $backup_data (true|false) : Set if you want to enable data backups site-wide. 
# $backup_log (true|false) : Set if you want to enable logs backups site-wide. 
# $backup_target : Set the ip/hostname you want to use on an external backup server to backup this host
# For the defaults of the above variables check rsync::params
#
# Usage:
# Automatically included if $backup=yes
#
class rsync::backup {

    include rsync::params

    backup { "rsync_data": 
        frequency => "${rsync::params::backup_frequency}",
        path      => "${rsync::params::datadir}",
        enabled   => "${rsync::params::backup_data_enable}",
        target    => "${rsync::params::backup_target_real}",
    }
    
    backup { "rsync_logs": 
        frequency => "${rsync::params::backup_frequency}",
        path      => "${rsync::params::logdir}",
        enabled   => "${rsync::params::backup_log_enable}",
        target    => "${rsync::params::backup_target_real}",
    }

    # Include project specific backup class if $my_project is set
    if $my_project { include "rsync::${my_project}::backup" }

}
