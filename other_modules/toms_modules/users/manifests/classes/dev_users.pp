# Class: users::dev_users
#
# Manages  users and groups
# Include it to install the dev users
#
# Usage:
# include users::dev_users


class users::dev_users inherits users {

  # Default group, 532, is build-devel
  Users::Manage_user { gid =>532,
    manage_homedir=>false,
  }

  users::manage_user { "cjackson":
    comment          => "Chris Jackson",
    uid              => "10032",
    gid              => "10032",
    other_groups     => ["wheel", "sysadmin", "build-devel" ],
    password         => "\$1\$s4DZnC/V\$IUKS8XjbQaq3o7D/.IgfD/",
    #ssh_rsa_auth_key =>  'AAAAB3NzaC1yc2EAAAABIwAAAQEA4i6QjBv/3h2bOa1MNSP1wd2/vZSe7ingZ2Z48ZkT8Rm+ca61XNqNTiJb4HW4cCuXdDORQLj8nYqEzMJIaDooeF/rI6Yf1YSklsBEHBwGrjQ2KHFGtIHrGHr0jOQrbb6kiH8/9qCsXqEaWsE+9c3D1lRoRfIqpQG18CxYzzCLelbivYOp2IbjllWqJKo5bai7rYf3UzuYVbrch2HVUWNs44IkuO9EzAv/fKVahj9kiQ8akygY34Y7Fc/azf1DMB1rI4QOcJrsNZmlmt7bpwNfVYNnITay06jhrAh5olqeU1jshfr8g0Q4BN3+SHKu+hnrb7kMcA47xOoRDGY/1zmO0w==',
  }

  users::manage_user { "cormsby":
    comment => "Chris Ormsby",
    uid       => 1009,
    other_groups => [ wheel, release ],
    password      => "\$1\$E6gc5Ri6\$yBldrF7ewqQlaN.kMUgaW1",
  }

  users::manage_user { "rgable":
    comment => "Robert Gable",
    uid       => 10025,
    other_groups => [ logs, release ],
    password     => "\$1\$mM8YxKNT\$J/Wh/o0JTOXZWDmVjBGxA/",
  }

  users::manage_user { jelliott:
    comment => "JD Elliott",
    uid       => 10021,
    other_groups => [ release ],
    password      => "\$1\$0BayCpmI\$SUoFVAEIhXOanyCJt2Nby1",
  }

}
