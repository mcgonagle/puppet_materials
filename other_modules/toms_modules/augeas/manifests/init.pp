# Class: augeas
#
# Manages augeas software 
# Include it to install and run augeas with default settings
#
# Usage:
# include augeas


import "classes/*.pp"
#import "defines/*.pp"

class augeas {
    package{"augeas": ensure => "0.7.4-1.el5",}
    package{"ruby-augeas": ensure => "0.3.0-1.el5",}
    package{"augeas-devel": ensure => "0.7.4-1.el5"}
    package{"augeas-libs": ensure => "0.7.4-1.el5"}

}#end of class augeas
