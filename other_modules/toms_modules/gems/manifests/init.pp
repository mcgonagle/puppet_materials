# Class: gems
#
# Manages gems software 
# Include it to install and run gems with default settings
#
# Usage:
# include gems

class gems {
    package{"rubygems": ensure => latest}
}#end of class gems
