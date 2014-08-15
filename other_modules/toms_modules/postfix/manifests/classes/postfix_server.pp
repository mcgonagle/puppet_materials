# postfix::server
#
# $Id: $
#
# Created 02/11 by wflynn
#
# For relay hosts.  These are mail servers that will handle mail from postfix::clients
#

class postfix::server inherits postfix {
  $inet_interfaces_default = [ "all" ]
  $spam_user = extlookup("postfix::spam_user")
  $spam_filter = extlookup("postfix::spam_filter")
  $content_filter_cmd = $spam_filter ? {
    "true" => " -o content_filter=$spam_user:dummy",
    "false" => "",
  }
  
  ## Genericized call:
    postfix::instance { "/etc/postfix":
      smarthost => "",
      
      bigdests  => extlookup("postfix::bigdests", unset),
      inet_interfaces => extlookup("postfix::inet_interfaces", $inet_interfaces_default),
      mynetworks => extlookup("postfix::mynetworks"),
      myorigin    => extlookup("postfix::myorigin"),
      relaydomains=> extlookup("postfix::relaydomains", unset),
      relaygateways => extlookup("postfix::relaygateways", unset),
      transport_template => extlookup("postfix::transport_template"),
      
      spam_user           => $spam_user,
      spam_filter         => $spam_filter,
      content_filter_cmd  => $content_filter_cmd,
    }

}
