# Copyright (C) 2007 David Schmitt <david@schmitt.edv-bus.at>
# See LICENSE for the full license granted to you.

# Usage:
# line { description:
#       file => "filename",
#       line => "content",
#       ensure => {absent,*present*}
# }
#
# Example:
# The following ensures that the line "allow ^$munin_host$" exists
# in /etc/munin/munin-node.conf, and if there are any changes notify the service for
# a restart
#
# line { allow_munin_host:
#       file => "/etc/munin/munin-node.conf",
#       line => "allow ^$munin_host$",
#       ensure => present,
#       notify => Service[munin-node],
#       require => Package[munin-node],
# }
#
#
define manhunt::line($file, $line, $ensure = 'present', $refreshonly = false) {
        case $ensure {
                default : { err ( "unknown ensure value '${ensure}'" ) }
                present: {
                        exec { "/bin/echo '${line}' >> '${file}'":
                                unless => "/bin/grep -qFx '${line}' '${file}'",
                                refreshonly => $refreshonly,
                        }
                }
                absent: {
                        exec { "/usr/bin/perl -ni -e 'print unless /^\\Q${line}\\E\$/' '${file}'":
                                onlyif => "/bin/grep -qFx '${line}' '${file}'",
                                refreshonly => $refreshonly,
                        }
                }
        }
}
