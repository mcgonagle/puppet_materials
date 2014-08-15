# Class: pam::ldap
#
# Pam settings for ldap authtentication
#
# Usage:
# include pam::ldap
#
class pam::ldap inherits pam {
# Load the variables used in this module. Check the params.pp file
    include pam::params

case "${pam::params::oslayout}" {

    debian5: { 
        File ["/etc/pam.d/common-account"] {
                source => "${pam::params::pam_source}/ldap/${pam::params::oslayout}/common-account",
        }
        File ["/etc/pam.d/common-auth"] {
                source => "${pam::params::pam_source}/ldap/${pam::params::oslayout}/common-auth",
        }
        File ["/etc/pam.d/common-password"] {
                source => "${pam::params::pam_source}/ldap/${pam::params::oslayout}/common-password",
        }
        File ["/etc/pam.d/common-session"] {
                source => "${pam::params::pam_source}/ldap/${pam::params::oslayout}/common-session",
        }
    }

    ubuntu104: {
        File ["/etc/pam.d/common-password"] {
                source => "${pam::params::pam_source}/ldap/${pam::params::oslayout}/common-password",
        }
    }

    redhat5: {
        File ["/etc/pam.d/system-auth-ac"] {
                source => "${pam::params::pam_source}/ldap/${pam::params::oslayout}/system-auth-ac",
        }
    }

} # End case

}
