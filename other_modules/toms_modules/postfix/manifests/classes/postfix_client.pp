# postfix::client
#
# $Id: $
#
# Created 02/11 by wflynn
#
# For non-relay hosts.  Every host that's not a mail server should have this.
#

class postfix::client inherits postfix {
  postfix::instance { "/etc/postfix":
    # smarthost gets set for client.pp, blanked for server.pp
    smarthost   => extlookup("postfix::smarthost"),
    mynetworks => extlookup("postfix::mynetworks"),
  }
}
