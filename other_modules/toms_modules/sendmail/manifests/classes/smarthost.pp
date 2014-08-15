class sendmail::smarthost inherits sendmail {

  $sendmail_listener = ""
  $sendmail_sm_directive = "dnl define(`SMART_HOST',`addr')dnl"

  file { "/etc/mail/sendmail.mc":
    content => template ( "sendmail/sendmail.mc.erb" ),
    mode => 644, owner => root, group => root,
  }
  exec { "m4 /etc/mail/sendmail.mc > /etc/mail/sendmail.cf":
    path => "/bin:/usr/bin",
    creates => "/etc/mail/sendmail.cf",
    subscribe => File [ "/etc/mail/sendmail.mc" ],
    notify => Service [ sendmail ],
    require => File["/etc/mail/sendmail.mc"],
  }

  file { "/etc/mail/relay-domains":
    content => ".$orgdomain
    .waltham.$orgdomain
    .cambridge.$orgdomain
    .dev.$orgdomain
    .qa.$orgdomain
    ",
    mode => 644, owner => root, group => root,
    notify => Service [ sendmail ],
  }
  service { sendmail:
    ensure => running,
    pattern => sendmail,
  }
}#end of sendmail::smarthost
