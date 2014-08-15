# Class: glassfish
#
# This module manages glassfish
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class glassfish(
    $service_enable = 'false',
    $service_ensure = 'stopped',
    $service_hasstatus = 'true',
    $service_hasrestart = 'true',
    $service_pattern = 'java -cp /usr/local/glassfishv3/glassfish/modules/glassfish.jar'
) inherits glassfish::params {

  include glassfish::install, glassfish::config, glassfish::service
  Class["glassfish::install"] -> Class["glassfish::config"] -> Class["glassfish::service"]


}
