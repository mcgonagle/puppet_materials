# Define mcollective::conf
#
# General mcollective main configuration file's inline modification define
# Use with caution, it's still at experimental stage and may break in untested circumstances
# Engine, pattern end line parameters can be tweaked for better behaviour
#
# Usage:
# mcollective::conf    { "mynetworks":  value => "127.0.0.0/8 10.42.42.0/24" }
#
define mcollective::conf ($value) {

    require mcollective::params

    config { "mcollective_conf_$name":
        file      => "${mcollective::params::configfile}",
        line      => "$name = $value",
        pattern   => "^$name ",
        engine    => "replaceline",
        notify    => Service["mcollective"],
        require   => File["mcollective.conf"],
    }

}
