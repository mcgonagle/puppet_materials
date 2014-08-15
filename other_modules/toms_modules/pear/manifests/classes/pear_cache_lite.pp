# Class: pear::cache_lite
#
# Installs Pear for PHP module
#
# Usage:
# include pear::cache_lite
class pear::cache_lite inherits pear {
  package{"php-pear-Cache-Lite": ensure => latest }
}#end of class pear::cache_lite
