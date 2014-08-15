# Module: tomcat
#
# Class: tomcat
#
# Description:
#       This class configures the tomcat software 
#
# Defines:
#       None
#
# Variables:
#       None
#
# Facts:
#
# Files:
#       tomcat
#       tomcat.sh
#       tomcat-users.xml
#       server.xml
# Templates:
#       tomcat-users.xml.erb
#
# TODO:
#
class tomcat {
  require tomcat::params
  include tomcat::install, tomcat::config, tomcat::service
}#end of class tomcat
