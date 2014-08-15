#!/usr/bin/env python
#
# apc_clear.py
#
# $Id: apc_clear.py,v 1.3 2009/09/25 23:16:02 wflynn Exp $
#
# WFlynn 09/09
#
# Python wrapper that makes a request to each webserver to call it's apc-clearing mechanism
#
import urllib
import urllib2

##For Testing
##hostlist=['01',]

hostlist=['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22',]

for host in hostlist:
    ##   URL Pointers Here:
    #        http://confluence.svc.cambridge.manhunt.net/display/SysEng/HOWTO+bounce+all+v4+cache
    #    APC CACHE URL:
    url = 'http://www' + host + '.v4.waltham.manhunt.net/index.php/user/apcClear/pass/w74byru4r416dfphj7jm2f'
    ## This block was from old CGI query string version.  Saving here for posterity.  Use full URL above.
    #url = 'http://www' + host + '.v4.waltham.manhunt.net/user/clear'
    #values = {'pass' : 'w74byru4r416dfphj7jm2f', }
    #data = urllib.urlencode(values)
    #req = urllib2.Request(url, data)
    req = urllib2.Request(url)
    response = urllib2.urlopen(req)
    content = response.read()

    print ">Done: www" + host + ":\t" + content + "<"

