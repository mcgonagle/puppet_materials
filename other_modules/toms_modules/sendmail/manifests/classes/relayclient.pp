class sendmail::relayclient inherits sendmail {
  
  # If a host needs to listen on port 25, add to this case

  $sendmail_listener = $hostname ? {
    admin02 => "",
    default => "Addr=127.0.0.1,"
  }

  $sendmail_sm_directive = $domain ? {
    "waltham.manhunt.net" => "define(`SMART_HOST', `smtp.$domain')dnl",
    "v4.waltham.manhunt.net" => "define(`SMART_HOST', `smtp.waltham.$orgdomain')dnl",
    "wal.manhunt.net" => "define(`SMART_HOST', `smtp.waltham.$orgdomain')dnl",
    default               => "define(`SMART_HOST', `smtp.$domain')dnl"
  }

  file { "/etc/mail/sendmail.mc":
    content => template ( "sendmail/sendmail.mc.erb" ),
    mode => 644, owner => root, group => root,
    require => [ Package["sendmail"], Package["sendmail-cf"] ], }

  exec { "m4 /etc/mail/sendmail.mc > /etc/mail/sendmail.cf":
    path => "/bin:/usr/bin",
    creates => "/etc/mail/sendmail.cf",
    subscribe => File [ "/etc/mail/sendmail.mc" ],
    notify => Service [ sendmail ],
    require => File [ "/etc/mail/sendmail.mc" ], }

  file { "/etc/mail/trusted-users":
    content => "# Auto-generated for $fqdn by puppet
    # users that can send mail to others without a warning
    apache
    ",
    mode => 644, owner => root, group => root,
    notify => Service["sendmail"],
    require => [ Package["sendmail"], Package["sendmail-cf"], File["/etc/mail/sendmail.mc"] ], }
  
  service { "sendmail":
    ensure => running,
    enable => true,
    pattern => sendmail,
    subscribe =>Exec ["m4 /etc/mail/sendmail.mc > /etc/mail/sendmail.cf"], }


}#end of sendmail::relayhost
