class users::system_users inherits users {

 user {"media": uid => "2013", gid => "media", 
      comment => "media user",
      home => "/home/media", }

 group { "media":
      ensure => present,
      gid => 2013,
      allowdupe => "false" }

 user {"ftp": uid => "14", gid => "50", 
      comment => "FTP User",
      home => "/var/ftp", }

 group {"ftp": ensure => present, gid => "50", allowdupe => false,
      before => User["ftp"], }

 users::nologin_user_def {"apache": uid => "48", gid => "48", }

 users::manage_user {"logs": 
      uid => "2001", gid => "2001",
      comment => "OLB Log Processor",
      password => "*",
      #ssh_dss_auth_key => "ssh-dss AAAAB3NzaC1kc3MAAACBAN0kXdA9nlus+Nh+2RXGoQowYzajkfVz99wiz+H1Ats7SK6YF8RLUiegG+2H84L7IauSajzFBQEO1X6edxQJR9Cf448DAbSAX8UpRch0PctfyTwJ3+485uGA5RKV9Tu+Gd/WykP9n/Xa4UaIUBrqKvtsNcHdVds7pQ+m9XftQJkFAAAAFQCFGVJ/zwbeJcnxqj3k1NRlg3DnKwAAAIEAvCKSA5sExhodyP0ofCf5/ja0gAp3BJ2yDl5DixbOfA4DWs27AugBxypj0IcLJcuyKSRAI8VHXnKYbG3+DMdAMyXufc5Qonrng4cUxCtCTVpHR5mjTS6V/ke+TQ6rocwJC7nNt3LiCJINQ4zYBkCZa4IZc0eIRDozR9nYGpFtNo0AAACANc2EVwH9XQIA/+dy8It6PW++YFiw65iNsHrewNZjiFhzmDSPrgfAYvPnxP4Pac6cxYjjkiuWVOELnx1y8F4gP9KTicsc6IuTIeLamEJy2owQNT/uWnHVv3ARbiWYJ5VJxrDKXmk2kitrIPqBAa02RQLRRE40JGvTFnQTqnN3SbY= logs@myna.manhunt.net",
       }
 #file { "/home/logs/.ssh/authorized_keys":
 #    ensure => false,
 #    content => "ssh-dss AAAAB3NzaC1kc3MAAACBAN0kXdA9nlus+Nh+2RXGoQowYzajkfVz99wiz+H1Ats7SK6YF8RLUiegG+2H84L7IauSajzFBQEO1X6edxQJR9Cf448DAbSAX8UpRch0PctfyTwJ3+485uGA5RKV9Tu+Gd/WykP9n/Xa4UaIUBrqKvtsNcHdVds7pQ+m9XftQJkFAAAAFQCFGVJ/zwbeJcnxqj3k1NRlg3DnKwAAAIEAvCKSA5sExhodyP0ofCf5/ja0gAp3BJ2yDl5DixbOfA4DWs27AugBxypj0IcLJcuyKSRAI8VHXnKYbG3+DMdAMyXufc5Qonrng4cUxCtCTVpHR5mjTS6V/ke+TQ6rocwJC7nNt3LiCJINQ4zYBkCZa4IZc0eIRDozR9nYGpFtNo0AAACANc2EVwH9XQIA/+dy8It6PW++YFiw65iNsHrewNZjiFhzmDSPrgfAYvPnxP4Pac6cxYjjkiuWVOELnx1y8F4gP9KTicsc6IuTIeLamEJy2owQNT/uWnHVv3ARbiWYJ5VJxrDKXmk2kitrIPqBAa02RQLRRE40JGvTFnQTqnN3SbY= logs@myna.manhunt.net
 #",
 #    mode => 600, owner => logs, group => logs,
 #    require => Users::Manage_user["logs"],
 #     }

 #I don't think we need to define a nrpe user, we should get this user via the rpm installation.
 #commenting out in puppet and lettting the uid/gid for nrpe be whatever gets installed via the rpm.
 #Tom M. 12-9-10
 #user {"nrpe": uid => "102", gid => "104",
      #shell => "/sbin/nologin",
      #comment => "NRPE user for the NRPE service",
      #require => Group["nrpe"], }

 #group {"nrpe": ensure => present, gid => "104", allowdupe => false,
      #before => User["nrpe"],
      #require => Class["users::purge_users"], }
      

  users::manage_user {"deploy":
        uid => "1011",
        gid => "1011",
        other_groups => ["build", "creative-editors" ],
        password => "*", 
        comment => "Deploy Account",
        #ssh_rsa_auth_key => "AAAAB3NzaC1yc2EAAAABIwAAAIEAuHZCo9SR/I+w9L6/5UTKCN01Y6/hb2icP5LUMxUpfwbaScX2EvrClV+oGR6wOcMnnb2IJjMHey6u+CnKB6QmumLC7ncC8MvBI6chXwSfCCGTVONMgukjoLb0Hpysc8jEHhLwMPtxCwZ7x+J6isAm0xnnC8TLqS5iVj7Hs72Per8=",
        }
  users::manage_user {"zenoss":
	uid => "1337",
	gid => "1337",
	password => "*",
	comment => "zenoss account", }

  users::manage_user {"build":
        uid => "1052",
        gid => "1052",
        other_groups => ["build", "build-devel" ],
        password => "*", 
        comment => "OLB builds",
        manage_homedir => "false",
        }

  users::manage_user {"care":
        uid => "2002",
        gid => "2002",
        other_groups => ["oinstall", "apache", "media" ],
        password => "*",
        comment => "OLB Care",
        }

  #file { "/home/care/.ssh/authorized_keys":
  #   ensure => false,
  #   content => "ssh-dss AAAAB3NzaC1kc3MAAACBAOQiXztTqyANVrALZmATSd/vFguktxIIKNqfPacFb+FtU/JE1jTjOzT4OJAFv6yOXkvBbxl7ADPop9cGbMZw7sN96lbQZBy9iBOB09n8oO1tc50XiIZaVkCmG1iuUuiqp5m0mM9yI881D9mmooECQpAl/0FlA48acD4cH3FlJN2HAAAAFQDOYnMI7Gndf1qhIMZVMzbjdwVe+wAAAIB5jV6CTi/Zr+kQKn7+Xl750yb+GCIslHScVZRtr7WwKeFBpSkcjYQwL3um1ypyEWA96U0PVLR9WI1dinwj3Rq7idDnGXl0AwoL95TzX8DDTRUZ8qUzPWTMx+Hui3+wRhPeuoOaoL+Cxudu66TVWf/FGfzQqlkeIVzP+MJ/4GkuOwAAAIAVeyhMNpOUuGqWw55CEbTU+UQJ3yOoQ1Ppp8nMdeMTvRLRasjwyhFikmWxuyOLxu1hMms6pRIM6XmApSwwji2zfiJHh9mtU/J+OZL45DRilKBzSJyqUjLyGoAzSenv57RDKJmuMt4Idz/6vuJBGhSelIKq1Xgmvkp+9FPUpdlPcw== care@tera-bactyl02.waltham.manhunt.net
  #    ssh-dss AAAAB3NzaC1kc3MAAACBAJW5VbJx5DQADY7iBP7hLZFNrLZqkZIgEw1ZPUnNgbPI/G9F6UPU+Tjp8zUiGCKPwLJTcKe/TlwOmPA41difqMhPBSedbZUotvJPaj8Pcj1/ggWa18vihFRQumtP6+S7U6Dy0bOpwlEdb+GGmuqk6M0W2+XaIijwizAagE2Dh4unAAAAFQDF99FqPNVRP5HD4yCXkirRUE+y8wAAAIEAinDWysXMnqHqUk5jqLdf4ylCzJ/m0rBY7wbt4Em5LIePcq1akskeGPxk+ZnKeEHmKenl/pSZR0Mg4RCTJPWVnF/FwFVcRQlwnz3wkciMXmmFwhKpDlHCO/aXnfmJjtVg4kUc0iJwVUaQlH6JUD5vppihk/4dxNVYK09TT86WEzgAAACAZguZ16i2u1LRoHQZtvc76FcTvRFkpKi15u0saORyZmPn2tTD5RP0xlbGiiI0YaxiB0/uGp7/FEA3ao2B5ubRcDUnV99+oYRHv5HHU8g2FPXyQwcD/a1mh1D38SZedi2V63ffLyuOHDu1GFMvmFJMxLnv75/5oNwVLGqvHuTqkKk= starling.waltham.manhunt.net
  #  ",
      #mode=> 600, owner => care, group => care,
      #require => Users::Manage_user["care"], }


  users::manage_user {"capi":
        uid => "2016",
        gid => "2016",
        other_groups => ["build" ],
        password => "*", 
        comment => "Capistrano User",
        #ssh_rsa_auth_key => "AAAAB3NzaC1yc2EAAAABIwAAAQEA0KuySqeh1yS42j752ogmpf2k21xcg2jDFzBq/T45GcJTzDfZwZo3qb8LUyd7OqB0LdJiuaO7Uoo1wcwgky099jKzoSg+86+K2MZ/f9Jud3dy1Y1dHeTmvuFf7uduz5G0EOrJzA1fMnWKceWF68OXCdO6t5QShdTjmRDCcns0gJ5fm1ZpAJ4WPNCsnykBWhCXzyjvqLS4YmGl8ZB3uLwq+uWqKgNZFf9V+xWWXgbtpR0WdHXSIlgASpNPMYFFiTb/VjIJB50wnywYo0O1gW22y6TwWMog4kPm4an9zudW81Jfl9UEiNxe2cByoUx5DK++kwUOJMENXPab8KnzoVIgWQ==",
        }

}#end of users::app_users
