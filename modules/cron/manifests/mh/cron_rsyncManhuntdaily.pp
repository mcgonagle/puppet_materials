class cron::cron_rsyncManhuntdaily inherits cron {
  manhunt_cron_item { "rsyncManhuntdaily.sh":
    user    => "care",

    # note from rbraun 6/10/2010 - got rid of day/hour asterisks, puppet does not
    # like asterisk
    # From Akshat: Why is it working if puppet doesn't like it?
    # From Rich: It's valid to say '*/15'.  It's invalid to say just '*'.  See
    # the comments in the manhunt_cron_item definition above.
    # --> To find out why for yourself, set up a cron on an offline test
    #   box and specify hour => '*', then tailf /var/log/messages while
    #   respinning puppet a couple times.

    minute  => "*/15",
    #  opts =>  "/var/www/html/wordpress/wp-content/ blogsite02 blogsite03 blogsite04"
  }

}
