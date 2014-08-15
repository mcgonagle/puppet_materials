class sendmail::mailaliases inherits sendmail {
    mailalias { root:     recipient => "monitor@$orgdomain" } 
    mailalias { help:     recipient => "support" }
    mailalias { info:     recipient => "support" }
    mailalias { comments: recipient => "support" }
    mailalias { admin:    recipient => "support" }
    mailalias { support:  recipient => "support@$orgdomain" }
    mailalias { apache:   recipient => "deadmail@$orgdomain" }
    mailalias { photos:   recipient => "photos@$orgdomain" }
   
    exec { "/usr/bin/newaliases && touch $firstrun/aliases_setup":
        subscribe => [ Mailalias [ root ],
                       Mailalias [ help ],
                       Mailalias [ info ],
                       Mailalias [ comments ],
                       Mailalias [ admin ],
                       Mailalias [ support ],
                       Mailalias [ apache ],
                       Mailalias [ photos ] ],
        creates => "$firstrun/aliases_setup",
    }   
}#end of sendmail::mail_aliases
