class manhunt::user_keys inherits manhunt {
  file { "/home/care/.ssh/id_dsa":
    content => '-----BEGIN DSA PRIVATE KEY-----
MIIBugIBAAKBgQDkIl87U6sgDVawC2ZgE0nf7xYLpLcSCCjanz2nBW/hbVPyRNY0
4zs0+DiQBb+sjl5LwW8ZewAz6KfXBmzGcO7DfepW0GQcvYgTgdPZ/KDtbXOdF4iG
WlZAphtYrlLoqqeZtJjPciPPNQ/ZpqKBAkKQJf9BZQOPGnA+HB9xZSTdhwIVAM5i
cwjsad1/WqEgxlUzNuN3BV77AoGAeY1egk4v2a/pECp+/l5e+dMm/hgiLJR0nFWU
ba+1sCnhQaUpHI2EMC97ptcqchFgPelND1S0fViNXYp8I90au4nQ5xl5dAMKC/eU
81/Aw00VGfKlMz1kzMfh7ot/sEYT3rqDmqC/gsbnbuuk1Vn/xRn80KpZHiFcz/jC
f+BpLjsCgYAVeyhMNpOUuGqWw55CEbTU+UQJ3yOoQ1Ppp8nMdeMTvRLRasjwyhFi
kmWxuyOLxu1hMms6pRIM6XmApSwwji2zfiJHh9mtU/J+OZL45DRilKBzSJyqUjLy
GoAzSenv57RDKJmuMt4Idz/6vuJBGhSelIKq1Xgmvkp+9FPUpdlPcwIUGWTEjpau
l2gQ8qds7+pCkswA4Kg=
-----END DSA PRIVATE KEY-----
    ',
    mode=> 600, owner => care, group => care,
    require => Manhunt::Ssh_subdir["care"],
  }#end of file definition


 file { "/home/logs/.ssh/id_dsa":
   content => '-----BEGIN DSA PRIVATE KEY-----
MIIBuwIBAAKBgQDdJF3QPZ5brPjYftkVxqEKMGM2o5H1c/fcIs/h9QLbO0iumBfE
S1InoBvth/OC+yGrkmo8xQUBDtV+nncUCUfQn+OPAwG0gF/FKUXIdD3LX8k8Cd/u
PObhgOUSlfU7vhnf1spD/Z/12uFGiFAa6ir7bDXB3VXbO6UPpvV37UCZBQIVAIUZ
Un/PBt4lyfGqPeTU1GWDcOcrAoGBALwikgObBMYaHcj9KHwn+f42tIAKdwSdsg5e
Q4sWznwOA1rNuwLoAccqY9CHCyXLsikkQCPFR15ymGxt/gzHQDMl7n3OUKJ654OH
FMQrQk1aR0eZo00ulf5Hvk0Oq6HMCQu5zbdy4giSDUOM2AZAmWuCGXNHiEQ6M0fZ
2BqRbTaNAoGANc2EVwH9XQIA/+dy8It6PW++YFiw65iNsHrewNZjiFhzmDSPrgfA
YvPnxP4Pac6cxYjjkiuWVOELnx1y8F4gP9KTicsc6IuTIeLamEJy2owQNT/uWnHV
v3ARbiWYJ5VJxrDKXmk2kitrIPqBAa02RQLRRE40JGvTFnQTqnN3SbYCFERLSBz0
NfWqL6gKYWuD4f2QRPjV
-----END DSA PRIVATE KEY-----
   ', 
   mode => 600, owner => logs, group => logs,
   require => Manhunt::Ssh_subdir["logs"],
 }

 file { "/home/capi/.ssh/authorized_keys":
    content => 'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA0KuySqeh1yS42j752ogmpf2k21xcg2jDFzBq/T45GcJTzDfZwZo3qb8LUyd7OqB0LdJiuaO7Uoo1wcwgky099jKzoSg+86+K2MZ/f9Jud3dy1Y1dHeTmvuFf7uduz5G0EOrJzA1fMnWKceWF68OXCdO6t5QShdTjmRDCcns0gJ5fm1ZpAJ4WPNCsnykBWhCXzyjvqLS4YmGl8ZB3uLwq+uWqKgNZFf9V+xWWXgbtpR0WdHXSIlgASpNPMYFFiTb/VjIJB50wnywYo0O1gW22y6TwWMog4kPm4an9zudW81Jfl9UEiNxe2cByoUx5DK++kwUOJMENXPab8KnzoVIgWQ== capi@itadm01.cambridge.manhunt.net
    ',  
    mode=> 644, owner => capi, group => sysadmin,
    require => Manhunt::Ssh_subdir["capi"],
  }
 


}#end of manhunt::user_keys
