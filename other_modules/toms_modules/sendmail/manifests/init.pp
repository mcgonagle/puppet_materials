# Class: sendmail
#
# Installs and manages sendmail.
# Include it to install and run sendmail with default settings
#
# A site will have one or two hosts set up for smart host relaying.  This
# defines the smarthost and client classes.
#
# Usage:
# include 


##import the defines and classes subdirectories
import "classes/*.pp"

class sendmail {
  package { sendmail: ensure => latest }
  package {"sendmail-cf": ensure => latest }

  include sendmail::relayclient
  include sendmail::mailaliases
}#end of sendmail class
