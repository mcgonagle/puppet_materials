class manhunt::authorized_keys inherits manhunt {

  case $primary_role {
    mhwww: {
      # Allow admin hosts to connect as deploy user
      file { "/home/deploy/.ssh/authorized_keys":
        content => "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAIEAuHZCo9SR/I+w9L6/5UTKCN01Y6/hb2icP5LUMxUpfwbaScX2EvrClV+oGR6wOcMnnb2IJjMHey6u+CnKB6QmumLC7ncC8MvBI6chXwSfCCGTVONMgukjoLb0Hpysc8jEHhLwMPtxCwZ7x+J6isAm0xnnC8TLqS5iVj7Hs72Per8= deploy@admin02.waltham.manhunt.net
        ",
        mode=> 600, owner => deploy, group => build,

      }
    }
    www: {
      # Allow admin hosts to connect as deploy user
      file { "/home/deploy/.ssh/authorized_keys":
        content => "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAIEAuHZCo9SR/I+w9L6/5UTKCN01Y6/hb2icP5LUMxUpfwbaScX2EvrClV+oGR6wOcMnnb2IJjMHey6u+CnKB6QmumLC7ncC8MvBI6chXwSfCCGTVONMgukjoLb0Hpysc8jEHhLwMPtxCwZ7x+J6isAm0xnnC8TLqS5iVj7Hs72Per8= deploy@admin02.waltham.manhunt.net
        ",
        mode=> 600, owner => deploy, group => build,

      }
    }
    qa_mhwww: {
      # Allow admin hosts to connect as deploy user
      file { "/home/deploy/.ssh/authorized_keys":
        content => "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAIEAuHZCo9SR/I+w9L6/5UTKCN01Y6/hb2icP5LUMxUpfwbaScX2EvrClV+oGR6wOcMnnb2IJjMHey6u+CnKB6QmumLC7ncC8MvBI6chXwSfCCGTVONMgukjoLb0Hpysc8jEHhLwMPtxCwZ7x+J6isAm0xnnC8TLqS5iVj7Hs72Per8= deploy@admin02.waltham.manhunt.net
        ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAuSq3WwzgJD1vO0rOlfH3hZolQMHIPAkakXFcy9E7V+qQkodfNAQK3R/F5bTPP72CCiAa6lP67yBcgAfMAl/b0pOCsjUGFrWSnUdSU/RuNGdOMAiYtHbGZfBhFaO4nUz+/92BjsP5KQwOwuD3aSrBG+ulhdhhCeRwTBjgec6iXRw1hVsl66A8rg+pjAd7PKC781AFI5dpDIRMWwS9+d7s0oX0xMQstR88CkqYlLFf1LHZ9Z65At4Gd6iYLpsXKzfSVH4QBRSoUFbs1nqTkalAd9du++UgjzGznm6gBF5y48DzIGFw9aVAfK4HQRPPaPir3ug+895LW44UfwdYasSETw== cconnors@monkey.dev.manhunt.net
        ssh-dss AAAAB3NzaC1kc3MAAACBAKpZ/rVIUApGzlqqb8bbn0A7OIUMawglXHOcBlWZLUpyIfaM4cCmHa0BNQ2TBxIgYGUcuSWIUl+FV6z7q1zEiqjSlqEPB2cHZCHOG1rWlkW0scfRP3cW5JqRLluhTsO4E60/bVNV2M0xMnCXXeUXupkn2D1Ee5LvSrYvacLBMt/TAAAAFQC+kGi7zMgu8rd3CiydZXgajmHIfQAAAIA6Mvb83AOVW3Ci19Jatzy+2lcwjRVCNgUcnMfqIMIb2RSAepAZ5aiYNP+DFxCsiQad4F5b6sM45JRtTO3afvpOoftETdrdNA9UTloaI8PyEWVHbFvG6rDfIMPps0OR4A6kjgsE2d642X/Qg0AtUyulVixnTDaX9jVcxa6KZon2ZAAAAIEAkXrdGpqaNYpTKBrNnDnu1e5a6Wf2S2tbEDc98JQHJVMcOk0i8tcwdtbV2OMI4SR8pPnryI7tgJbYdNc6AnvjA90GTv1MWnZlD71ZsW1mV4evzO6f+txi7S4SUf3KS7zxreulne+fYa0sRcJyaEqmg5nNhS86cBWNpA5+UDA6Io4= build@monkey.dev.manhunt.net
        ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA/HQYR9TYNOS5Fz7ltBmJ+BuI/YsZISGJx9eqaD/sPftvoGPKVm+UQPTrCv1O0+scyPRsYnKdcsZ45XvSKB8xMESg/bQHdu2YkwHrM99HjKcvqWsavJH2yjiV+hfEyuXJbijUKDNIlzt0/zcHiDsCb0xynM0l7WbiSGeAdmsOiThRxu5UiEfjX3DAmirltGUtA8Kzjfdoqv78OERHb6hDYR50JBr8cU0LmTb3KPPskSLpUEEQ7cnZBODGSZHIxMJEqlKLbJkKnV9Di0t5fj36MOQF37db4TSYUMfAq2eaBRMA5rUyvSc+XVAvS4T//5oxway2JMiN1FIsV0XxFvucLQ== build@monkey.dev.manhunt.net
        ssh-dss AAAAB3NzaC1kc3MAAACBAPo6Lk/cataTSvLV6DwdnX5Iy5YKsJKseNooztbZOT/jwEHY3sI8pMaipDNivkLq5QgvTDq5SWc9xjWrobO4lEbptosjX3yjsBjsom0xeGBG4pWnBaMkd+L1NIpo+kFUBAhsApGlziq23vkMMj3+rMJB8+BKoUIjtzKVHZu3EcTDAAAAFQCmru5SvptlGoi872XUuXMjh2nfqwAAAIAcn+/Ko4cF0C5jblscoqPYbgw7yRF3dYbVBnjWeyZtp00Jtklf5/9rvw0QJs8siUs+RDwl5lHBfX0JWV1659iA79tn9UzbPYNrzN7iUbutNW+ayVkmHRwdkyjKgMb2p9vAfPimN7tEYgYgU06kATZwQl4ljHuek3HaFNCVGSaz9wAAAIEA0NRKE9utOAbJVNX5Bnh8TG+MZRE9UwsbwV4fxCCCU482y1/ocBoezqTdnDCaj+E1bN3O1LvceIUBzcg3OeBFYOFU+ETl1g13Yjg9L+s7noSjucsop8CQPZw0YRNz9tTprZ+hIuvWev16//tFUEK3ViAxsCMLeVc3zIPLz+a0mOs= build user key
        ",
        mode=> 600, owner => deploy, group => build,
      }
    }
    #End of qa_mhwww

    presence: {
      # Alow Chris Connors to connect to the presenece servers with the build user
      file { "/home/deploy/.ssh/authorized_keys":
        content => "ssh-dss AAAAB3NzaC1kc3MAAACBAPo6Lk/cataTSvLV6DwdnX5Iy5YKsJKseNooztbZOT/jwEHY3sI8pMaipDNivkLq5QgvTDq5SWc9xjWrobO4lEbptosjX3yjsBjsom0xeGBG4pWnBaMkd+L1NIpo+kFUBAhsApGlziq23vkMMj3+rMJB8+BKoUIjtzKVHZu3EcTDAAAAFQCmru5SvptlGoi872XUuXMjh2nfqwAAAIAcn+/Ko4cF0C5jblscoqPYbgw7yRF3dYbVBnjWeyZtp00Jtklf5/9rvw0QJs8siUs+RDwl5lHBfX0JWV1659iA79tn9UzbPYNrzN7iUbutNW+ayVkmHRwdkyjKgMb2p9vAfPimN7tEYgYgU06kATZwQl4ljHuek3HaFNCVGSaz9wAAAIEA0NRKE9utOAbJVNX5Bnh8TG+MZRE9UwsbwV4fxCCCU482y1/ocBoezqTdnDCaj+E1bN3O1LvceIUBzcg3OeBFYOFU+ETl1g13Yjg9L+s7noSjucsop8CQPZw0YRNz9tTprZ+hIuvWev16//tFUEK3ViAxsCMLeVc3zIPLz+a0mOs= build user key
        ",
        mode=> 600, owner => deploy, group => build,
      }
    }
    #End of presence
    media_server: {
      # Alow Chris Connors to connect to the media servers with the build user
      file { "/home/deploy/.ssh/authorized_keys":
        content => "ssh-dss AAAAB3NzaC1kc3MAAACBAPo6Lk/cataTSvLV6DwdnX5Iy5YKsJKseNooztbZOT/jwEHY3sI8pMaipDNivkLq5QgvTDq5SWc9xjWrobO4lEbptosjX3yjsBjsom0xeGBG4pWnBaMkd+L1NIpo+kFUBAhsApGlziq23vkMMj3+rMJB8+BKoUIjtzKVHZu3EcTDAAAAFQCmru5SvptlGoi872XUuXMjh2nfqwAAAIAcn+/Ko4cF0C5jblscoqPYbgw7yRF3dYbVBnjWeyZtp00Jtklf5/9rvw0QJs8siUs+RDwl5lHBfX0JWV1659iA79tn9UzbPYNrzN7iUbutNW+ayVkmHRwdkyjKgMb2p9vAfPimN7tEYgYgU06kATZwQl4ljHuek3HaFNCVGSaz9wAAAIEA0NRKE9utOAbJVNX5Bnh8TG+MZRE9UwsbwV4fxCCCU482y1/ocBoezqTdnDCaj+E1bN3O1LvceIUBzcg3OeBFYOFU+ETl1g13Yjg9L+s7noSjucsop8CQPZw0YRNz9tTprZ+hIuvWev16//tFUEK3ViAxsCMLeVc3zIPLz+a0mOs= build user key
        ",
        mode=> 600, owner => deploy, group => build,

      }
    }
    #End of Media_server
    media: {
      # Alow Chris Connors to connect to the media150 qa boxes  with the build user
      file { "/home/deploy/.ssh/authorized_keys":
        content => "ssh-dss AAAAB3NzaC1kc3MAAACBAPo6Lk/cataTSvLV6DwdnX5Iy5YKsJKseNooztbZOT/jwEHY3sI8pMaipDNivkLq5QgvTDq5SWc9xjWrobO4lEbptosjX3yjsBjsom0xeGBG4pWnBaMkd+L1NIpo+kFUBAhsApGlziq23vkMMj3+rMJB8+BKoUIjtzKVHZu3EcTDAAAAFQCmru5SvptlGoi872XUuXMjh2nfqwAAAIAcn+/Ko4cF0C5jblscoqPYbgw7yRF3dYbVBnjWeyZtp00Jtklf5/9rvw0QJs8siUs+RDwl5lHBfX0JWV1659iA79tn9UzbPYNrzN7iUbutNW+ayVkmHRwdkyjKgMb2p9vAfPimN7tEYgYgU06kATZwQl4ljHuek3HaFNCVGSaz9wAAAIEA0NRKE9utOAbJVNX5Bnh8TG+MZRE9UwsbwV4fxCCCU482y1/ocBoezqTdnDCaj+E1bN3O1LvceIUBzcg3OeBFYOFU+ETl1g13Yjg9L+s7noSjucsop8CQPZw0YRNz9tTprZ+hIuvWev16//tFUEK3ViAxsCMLeVc3zIPLz+a0mOs= build user key
        ",
        mode=> 600, owner => deploy, group => build,
      }
    }
    #End of Media
    pounder_server: {
      # Alow Chris Connors to connect to the pounder servers with the build user
      file { "/home/deploy/.ssh/authorized_keys":
        content => "ssh-dss AAAAB3NzaC1kc3MAAACBAPo6Lk/cataTSvLV6DwdnX5Iy5YKsJKseNooztbZOT/jwEHY3sI8pMaipDNivkLq5QgvTDq5SWc9xjWrobO4lEbptosjX3yjsBjsom0xeGBG4pWnBaMkd+L1NIpo+kFUBAhsApGlziq23vkMMj3+rMJB8+BKoUIjtzKVHZu3EcTDAAAAFQCmru5SvptlGoi872XUuXMjh2nfqwAAAIAcn+/Ko4cF0C5jblscoqPYbgw7yRF3dYbVBnjWeyZtp00Jtklf5/9rvw0QJs8siUs+RDwl5lHBfX0JWV1659iA79tn9UzbPYNrzN7iUbutNW+ayVkmHRwdkyjKgMb2p9vAfPimN7tEYgYgU06kATZwQl4ljHuek3HaFNCVGSaz9wAAAIEA0NRKE9utOAbJVNX5Bnh8TG+MZRE9UwsbwV4fxCCCU482y1/ocBoezqTdnDCaj+E1bN3O1LvceIUBzcg3OeBFYOFU+ETl1g13Yjg9L+s7noSjucsop8CQPZw0YRNz9tTprZ+hIuvWev16//tFUEK3ViAxsCMLeVc3zIPLz+a0mOs= build user key
        ",
        mode=> 600, owner => deploy, group => build,
      }
    }
    #End of pounder
    developer: {
      # Alow Chris Connors to connect to the zend01-zend03 servers with the build user
      file { "/home/deploy/.ssh/authorized_keys":
        content => "ssh-dss AAAAB3NzaC1kc3MAAACBAPo6Lk/cataTSvLV6DwdnX5Iy5YKsJKseNooztbZOT/jwEHY3sI8pMaipDNivkLq5QgvTDq5SWc9xjWrobO4lEbptosjX3yjsBjsom0xeGBG4pWnBaMkd+L1NIpo+kFUBAhsApGlziq23vkMMj3+rMJB8+BKoUIjtzKVHZu3EcTDAAAAFQCmru5SvptlGoi872XUuXMjh2nfqwAAAIAcn+/Ko4cF0C5jblscoqPYbgw7yRF3dYbVBnjWeyZtp00Jtklf5/9rvw0QJs8siUs+RDwl5lHBfX0JWV1659iA79tn9UzbPYNrzN7iUbutNW+ayVkmHRwdkyjKgMb2p9vAfPimN7tEYgYgU06kATZwQl4ljHuek3HaFNCVGSaz9wAAAIEA0NRKE9utOAbJVNX5Bnh8TG+MZRE9UwsbwV4fxCCCU482y1/ocBoezqTdnDCaj+E1bN3O1LvceIUBzcg3OeBFYOFU+ETl1g13Yjg9L+s7noSjucsop8CQPZw0YRNz9tTprZ+hIuvWev16//tFUEK3ViAxsCMLeVc3zIPLz+a0mOs= build user key
        ",
        mode=> 600, owner => deploy, group => build,
      }
    }
    #End of developer
    developer_build_box: {
      # Alow Chris Connors to connect to the zend01-zend03 servers with the build user
      file { "/home/deploy/.ssh/authorized_keys":
        content => "ssh-dss AAAAB3NzaC1kc3MAAACBAPo6Lk/cataTSvLV6DwdnX5Iy5YKsJKseNooztbZOT/jwEHY3sI8pMaipDNivkLq5QgvTDq5SWc9xjWrobO4lEbptosjX3yjsBjsom0xeGBG4pWnBaMkd+L1NIpo+kFUBAhsApGlziq23vkMMj3+rMJB8+BKoUIjtzKVHZu3EcTDAAAAFQCmru5SvptlGoi872XUuXMjh2nfqwAAAIAcn+/Ko4cF0C5jblscoqPYbgw7yRF3dYbVBnjWeyZtp00Jtklf5/9rvw0QJs8siUs+RDwl5lHBfX0JWV1659iA79tn9UzbPYNrzN7iUbutNW+ayVkmHRwdkyjKgMb2p9vAfPimN7tEYgYgU06kATZwQl4ljHuek3HaFNCVGSaz9wAAAIEA0NRKE9utOAbJVNX5Bnh8TG+MZRE9UwsbwV4fxCCCU482y1/ocBoezqTdnDCaj+E1bN3O1LvceIUBzcg3OeBFYOFU+ETl1g13Yjg9L+s7noSjucsop8CQPZw0YRNz9tTprZ+hIuvWev16//tFUEK3ViAxsCMLeVc3zIPLz+a0mOs= build user key
        ",
        mode=> 600, owner => deploy, group => build,
      }
    }
    #End of developer_build_box

    weblog: {
      # Allow web frontends access to logs directory as user logs
      ssh_subdir { logs: }
      file { "/home/logs/.ssh/authorized_keys":
        content => "ssh-dss AAAAB3NzaC1kc3MAAACBAN0kXdA9nlus+Nh+2RXGoQowYzajkfVz99wiz+H1Ats7SK6YF8RLUiegG+2H84L7IauSajzFBQEO1X6edxQJR9Cf448DAbSAX8UpRch0PctfyTwJ3+485uGA5RKV9Tu+Gd/WykP9n/Xa4UaIUBrqKvtsNcHdVds7pQ+m9XftQJkFAAAAFQCFGVJ/zwbeJcnxqj3k1NRlg3DnKwAAAIEAvCKSA5sExhodyP0ofCf5/ja0gAp3BJ2yDl5DixbOfA4DWs27AugBxypj0IcLJcuyKSRAI8VHXnKYbG3+DMdAMyXufc5Qonrng4cUxCtCTVpHR5mjTS6V/ke+TQ6rocwJC7nNt3LiCJINQ4zYBkCZa4IZc0eIRDozR9nYGpFtNo0AAACANc2EVwH9XQIA/+dy8It6PW++YFiw65iNsHrewNZjiFhzmDSPrgfAYvPnxP4Pac6cxYjjkiuWVOELnx1y8F4gP9KTicsc6IuTIeLamEJy2owQNT/uWnHVv3ARbiWYJ5VJxrDKXmk2kitrIPqBAa02RQLRRE40JGvTFnQTqnN3SbY= logs@myna.manhunt.net
",
        mode => 600, owner => logs, group => logs,
        require => Manhunt::Ssh_subdir [ logs ],
      }
    }
  }
  #End of Primary Role
  file { "/home/care/.ssh/authorized_keys":
    content => "ssh-dss AAAAB3NzaC1kc3MAAACBAOQiXztTqyANVrALZmATSd/vFguktxIIKNqfPacFb+FtU/JE1jTjOzT4OJAFv6yOXkvBbxl7ADPop9cGbMZw7sN96lbQZBy9iBOB09n8oO1tc50XiIZaVkCmG1iuUuiqp5m0mM9yI881D9mmooECQpAl/0FlA48acD4cH3FlJN2HAAAAFQDOYnMI7Gndf1qhIMZVMzbjdwVe+wAAAIB5jV6CTi/Zr+kQKn7+Xl750yb+GCIslHScVZRtr7WwKeFBpSkcjYQwL3um1ypyEWA96U0PVLR9WI1dinwj3Rq7idDnGXl0AwoL95TzX8DDTRUZ8qUzPWTMx+Hui3+wRhPeuoOaoL+Cxudu66TVWf/FGfzQqlkeIVzP+MJ/4GkuOwAAAIAVeyhMNpOUuGqWw55CEbTU+UQJ3yOoQ1Ppp8nMdeMTvRLRasjwyhFikmWxuyOLxu1hMms6pRIM6XmApSwwji2zfiJHh9mtU/J+OZL45DRilKBzSJyqUjLyGoAzSenv57RDKJmuMt4Idz/6vuJBGhSelIKq1Xgmvkp+9FPUpdlPcw== care@tera-bactyl02.waltham.manhunt.net
    ssh-dss AAAAB3NzaC1kc3MAAACBAJW5VbJx5DQADY7iBP7hLZFNrLZqkZIgEw1ZPUnNgbPI/G9F6UPU+Tjp8zUiGCKPwLJTcKe/TlwOmPA41difqMhPBSedbZUotvJPaj8Pcj1/ggWa18vihFRQumtP6+S7U6Dy0bOpwlEdb+GGmuqk6M0W2+XaIijwizAagE2Dh4unAAAAFQDF99FqPNVRP5HD4yCXkirRUE+y8wAAAIEAinDWysXMnqHqUk5jqLdf4ylCzJ/m0rBY7wbt4Em5LIePcq1akskeGPxk+ZnKeEHmKenl/pSZR0Mg4RCTJPWVnF/FwFVcRQlwnz3wkciMXmmFwhKpDlHCO/aXnfmJjtVg4kUc0iJwVUaQlH6JUD5vppihk/4dxNVYK09TT86WEzgAAACAZguZ16i2u1LRoHQZtvc76FcTvRFkpKi15u0saORyZmPn2tTD5RP0xlbGiiI0YaxiB0/uGp7/FEA3ao2B5ubRcDUnV99+oYRHv5HHU8g2FPXyQwcD/a1mh1D38SZedi2V63ffLyuOHDu1GFMvmFJMxLnv75/5oNwVLGqvHuTqkKk= starling.waltham.manhunt.net
    ",
    mode=> 600, owner => care, group => care,
    require => Manhunt::Ssh_subdir [ care ],
  }

}#end of authorized_keys class
