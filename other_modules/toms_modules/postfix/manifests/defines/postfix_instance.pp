# postfix.pp
# $Id: postfix.pp,v 1.9 2010/12/21 21:57:26 wflynn Exp $
#
# Created 10/08 by rbraun

# Cleaned up function definition

define postfix::instance (
  # $name parameter value is ignored, for now please set to "/etc/postfix"

  $myhostname = $fqdn,
  #   domain name to set as myhostname

  $smarthost = "",
  #   name of server to send all mail to, if local machine is not sending direct
  #   to the whole Internet

  $relaydomains = unset,
  #   specify an *array* of domain names for which this server is relaying inbound mail
  #   to another internal server
  #   this array much match up member-to-member (index to index) with relaygateways

  $relaygateways = unset,
  #   specify an *array* of gateways thru which this server will relay the above domains
  #   this array much match up member-to-member (index to index) with relaydomains

  $internal_gw = unset,
  #   name or IP address of internal MX server handling inbound mail for which this
  #   server is acting as relay

  $virtual_alias_maps = "",
  #   command to set a virtual alias map, e.g.
  #     "virtual_alias_maps = hash:/etc/postfix/virtual"

  $mynetworks_settings = "",

  $mynetworks = "",
  
  $daemon_dir = "/usr/libexec/postfix",
  $myorigin = $orgdomain,
  $execsuffix = ".postfix",
  $setgid_group = "postdrop",

  $spam_filter = false,
  #   if a spam filter module is installed on this machine, enable this flag

  $spam_user = spamfilter,
  #   run the spam filter script as this user

  $spam_script = "/usr/local/bin/spamfilter.sh",
  #   run spam through this script

  $content_filter_cmd = "",

  $bigdests = unset,
  #   big destinations such as gmail

  $queue_life = "2d",
  $queue_warn = "0h",

  $transport_template = "postfix-transport.erb",
  $inet_interfaces = [ "all" ]
)
{
  $relay_domains_cmd = $relaydomains ? { unset => "", default => "relay_domains =" }
  $relaydests        = $relaydomains ? { unset => [], default => $relaydomains }
  $relaygws          = $relaygateways ? { unset => [], default => $relaygateways }

  $sfcmd = "spamfilter unix - n n - - pipe
  flags=Rq user=$spam_user argv=$spam_script -f \${sender} -- \${recipient}
  "
  $spamfilter_cmd = $spam_filter ? { true => $sfcmd, default => "" }
  $relayhost_cmd  = $smarthost ? { "" => "", default => "relayhost = $smarthost" }

  # Config-file parameters: install only after package, and restart the
  # postfix daemon any time any of these are updated
  File {
    owner   => root, group => root, mode => 644,
    require => Package [ "postfix" ],
    notify  => Service [ postfix ],
  }

  # Config files - these are drawn from the erb templates in this module
  file {
    "/etc/postfix/main.cf":
      content => template ( "postfix/postfix-main.cf.erb" );

    "/etc/postfix/master.cf":
      content => template ("postfix/postfix-master.cf.erb");

    "/etc/postfix/transport":
      content => template ( "postfix/$transport_template" ),
      notify  => Exec [ "postmap transport" ];
  }

  # Special config file:  any time the 'transport' map file is updated, invoke
  # the postmap command and restart daemon
  exec { "postmap transport":
    path    => [ "/usr/sbin", "/sbin", "/bin" ],
    cwd     => "/etc/postfix",
    refreshonly => true,
    notify  => Service [ postfix ],
  }
  
  
  service { sendmail:
    ensure => false,
    enable => false,
  }

  service { postfix:
    ensure => true,
    enable => true,
    require => Service [ sendmail ],
  }
  
  
  # Postfix is pre-loaded on our openSUSE systems but not on RedHat
}
# end of postfix::instance
