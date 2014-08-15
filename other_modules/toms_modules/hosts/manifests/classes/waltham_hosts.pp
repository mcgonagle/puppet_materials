class hosts::waltham inherits hosts {
#cat host_list.txt |awk '{ print "host {\"" $2 "\": \n\tip => \"" $1"\",\n\tensure => \"present\", }" }'
#host { "${servername}":
          #ip => "${serverip}",
          #host_aliases => [ "puppet", "puppet.${domain}" ],
          #ensure => "present", }

host {"cobitpd01.wal.manhunt.net": 
	ip => "192.168.1.10",
	ensure => "present", }

host {"dbads02.waltham.manhunt.net": 
	ip => "192.168.1.100",
	ensure => "present", }

host {"dbiphone01.waltham.manhunt.net": 
	ip => "192.168.1.101",
	ensure => "present", }

host {"www23.v4.waltham.manhunt.net": 
	ip => "192.168.1.102",
	ensure => "present", }

host {"www24.v4.waltham.manhunt.net": 
	ip => "192.168.1.103",
	ensure => "present", }

host {"www25.v4.waltham.manhunt.net": 
	ip => "192.168.1.104",
	ensure => "present", }

host {"www26.v4.waltham.manhunt.net": 
	ip => "192.168.1.105",
	ensure => "present", }

host {"db-bactyl03.waltham.manhunt.net": 
	ip => "192.168.1.106",
	ensure => "present", }

host {"db06.waltham.manhunt.net": 
	ip => "192.168.1.106",
	ensure => "present", }

host {"maindb02.v4.waltham.manhunt.net": 
	ip => "192.168.1.107",
	ensure => "present", }

host {"ids02.waltham.manhunt.net": 
	ip => "192.168.1.108",
	ensure => "present", }

host {"smtplv.waltham.manhunt.net": 
	ip => "192.168.1.109",
	ensure => "present", }

host {"smtplv01.waltham.manhunt.net": 
	ip => "192.168.1.109",
	ensure => "present", }

host {"mail01.v4.waltham.manhunt.net": 
	ip => "192.168.1.11",
	ensure => "present", }

host {"smtplv02.waltham.manhunt.net": 
	ip => "192.168.1.110",
	ensure => "present", }

host {"mainro10.v4.waltham.manhunt.net": 
	ip => "192.168.1.111",
	ensure => "present", }

host {"mainro10.waltham.manhunt.net": 
	ip => "192.168.1.111",
	ensure => "present", }

host {"dbadsro04.waltham.manhunt.net": 
	ip => "192.168.1.112",
	ensure => "present", }

host {"dlmedia01.waltham.manhunt.net": 
	ip => "192.168.1.113",
	ensure => "present", }

host {"dlmedia02.waltham.manhunt.net": 
	ip => "192.168.1.114",
	ensure => "present", }

host {"dlads01.waltham.manhunt.net": 
	ip => "192.168.1.115",
	ensure => "present", }

host {"dlads02.waltham.manhunt.net": 
	ip => "192.168.1.116",
	ensure => "present", }

host {"bkp-trackdb00.waltham.manhunt.net": 
	ip => "192.168.1.117",
	ensure => "present", }

host {"openxdb01.waltham.manhunt.net": 
	ip => "192.168.1.118",
	ensure => "present", }

host {"openxdb02.waltham.manhunt.net": 
	ip => "192.168.1.119",
	ensure => "present", }

host {"dw06.waltham.manhunt.net": 
	ip => "192.168.1.12",
	ensure => "present", }

host {"web01.waltham.manhunt.net": 
	ip => "192.168.1.120",
	ensure => "present", }

host {"web02.waltham.manhunt.net": 
	ip => "192.168.1.121",
	ensure => "present", }

host {"logviewer01.waltham.manhunt.net": 
	ip => "192.168.1.122",
	ensure => "present", }

host {"wdns02.waltham.manhunt.net": 
	ip => "192.168.1.123",
	ensure => "present", }

host {"web03.waltham.manhunt.net": 
	ip => "192.168.1.124",
	ensure => "present", }

host {"mailshard01.waltham.manhunt.net": 
	ip => "192.168.1.125",
	ensure => "present", }

host {"mailshard02.waltham.manhunt.net": 
	ip => "192.168.1.126",
	ensure => "present", }

host {"mailshard03.waltham.manhunt.net": 
	ip => "192.168.1.127",
	ensure => "present", }

host {"mailshard04.waltham.manhunt.net": 
	ip => "192.168.1.128",
	ensure => "present", }

host {"maindb00.v4.waltham.manhunt.net": 
	ip => "192.168.1.129",
	ensure => "present", }

host {"mail02.v4.waltham.manhunt.net": 
	ip => "192.168.1.13",
	ensure => "present", }

host {"billing03.v4.waltham.manhunt.net": 
	ip => "192.168.1.131",
	ensure => "present", }

host {"admin42.v4.waltham.manhunt.net": 
	ip => "192.168.1.133",
	ensure => "present", }

host {"vmware06.waltham.manhunt.net": 
	ip => "192.168.1.134",
	ensure => "present", }

host {"billing04.v4.waltham.manhunt.net": 
	ip => "192.168.1.135",
	ensure => "present", }

host {"billing05.v4.waltham.manhunt.net": 
	ip => "192.168.1.136",
	ensure => "present", }

host {"gallery00.v4.waltham.manhunt.net": 
	ip => "192.168.1.137",
	ensure => "present", }

host {"web04.waltham.manhunt.net": 
	ip => "192.168.1.137",
	ensure => "present", }

host {"mainro02.v4.waltham.manhunt.net": 
	ip => "192.168.1.138",
	ensure => "present", }

host {"mainro02.waltham.manhunt.net": 
	ip => "192.168.1.138",
	ensure => "present", }

host {"mainro03.v4.waltham.manhunt.net": 
	ip => "192.168.1.139",
	ensure => "present", }

host {"mainro03.waltham.manhunt.net": 
	ip => "192.168.1.139",
	ensure => "present", }

host {"mail03.v4.waltham.manhunt.net": 
	ip => "192.168.1.14",
	ensure => "present", }

host {"mainro04.waltham.manhunt.net": 
	ip => "192.168.1.140",
	ensure => "present", }

host {"www27.v4.waltham.manhunt.net": 
	ip => "192.168.1.141",
	ensure => "present", }

host {"www13.v4.waltham.manhunt.net": 
	ip => "192.168.1.142",
	ensure => "present", }

host {"chat03.waltham.manhunt.net": 
	ip => "192.168.1.143",
	ensure => "present", }

host {"chat04.waltham.manhunt.net": 
	ip => "192.168.1.144",
	ensure => "present", }

host {"dbadsro05.waltham.manhunt.net": 
	ip => "192.168.1.145",
	ensure => "present", }

host {"www35.waltham.manhunt.net": 
	ip => "192.168.1.146",
	ensure => "present", }

host {"www36.waltham.manhunt.net": 
	ip => "192.168.1.147",
	ensure => "present", }

host {"www18.v4.waltham.manhunt.net": 
	ip => "192.168.1.148",
	ensure => "present", }

host {"www19.v4.waltham.manhunt.net": 
	ip => "192.168.1.149",
	ensure => "present", }

host {"mail04.v4.waltham.manhunt.net": 
	ip => "192.168.1.15",
	ensure => "present", }

host {"www20.v4.waltham.manhunt.net": 
	ip => "192.168.1.150",
	ensure => "present", }

host {"www21.v4.waltham.manhunt.net": 
	ip => "192.168.1.151",
	ensure => "present", }

host {"www22.v4.waltham.manhunt.net": 
	ip => "192.168.1.152",
	ensure => "present", }

host {"www15.v4.waltham.manhunt.net": 
	ip => "192.168.1.153",
	ensure => "present", }

host {"www16.v4.waltham.manhunt.net": 
	ip => "192.168.1.154",
	ensure => "present", }

host {"www17.v4.waltham.manhunt.net": 
	ip => "192.168.1.155",
	ensure => "present", }

host {"www17.waltham.manhunt.net": 
	ip => "192.168.1.155",
	ensure => "present", }

host {"smtp-admin02c.waltham.manhunt.net": 
	ip => "192.168.1.156",
	ensure => "present", }

host {"smtp-twothree.waltham.manhunt.net": 
	ip => "192.168.1.156",
	ensure => "present", }

host {"smtp-twothreefour.waltham.manhunt.net": 
	ip => "192.168.1.156",
	ensure => "present", }

host {"smtpb.waltham.manhunt.net": 
	ip => "192.168.1.156",
	ensure => "present", }

host {"smtp03.waltham.manhunt.net": 
	ip => "192.168.1.156",
	ensure => "present", }

host {"www14.v4.waltham.manhunt.net": 
	ip => "192.168.1.157",
	ensure => "present", }

host {"smtp-admin02d.waltham.manhunt.net": 
	ip => "192.168.1.158",
	ensure => "present", }

host {"smtp-onetwob.waltham.manhunt.net": 
	ip => "192.168.1.158",
	ensure => "present", }

host {"smtp-twothreeb.waltham.manhunt.net": 
	ip => "192.168.1.158",
	ensure => "present", }

host {"smtp-twothreefourb.waltham.manhunt.net": 
	ip => "192.168.1.158",
	ensure => "present", }

host {"smtpc.waltham.manhunt.net": 
	ip => "192.168.1.158",
	ensure => "present", }

host {"smtp02.waltham.manhunt.net": 
	ip => "192.168.1.158",
	ensure => "present", }

host {"openxadm03.waltham.manhunt.net": 
	ip => "192.168.1.159",
	ensure => "present", }

host {"maildb05.v4.waltham.manhunt.net": 
	ip => "192.168.1.16",
	ensure => "present", }

host {"idns04.svc.waltham.manhunt.net": 
	ip => "192.168.1.160",
	ensure => "present", }

host {"idns05.svc.waltham.manhunt.net": 
	ip => "192.168.1.161",
	ensure => "present", }

host {"www37.waltham.manhunt.net": 
	ip => "192.168.1.162",
	ensure => "present", }

host {"edns02.waltham.manhunt.net": 
	ip => "192.168.1.163",
	ensure => "present", }

host {"mystery1.waltham.manhunt.net": 
	ip => "192.168.1.164",
	ensure => "present", }

host {"stg-dlist.waltham.manhunt.net": 
	ip => "192.168.1.165",
	ensure => "present", }

host {"mailshard01b.waltham.manhunt.net": 
	ip => "192.168.1.167",
	ensure => "present", }

host {"mailshard02b.waltham.manhunt.net": 
	ip => "192.168.1.168",
	ensure => "present", }

host {"mailshard03b.waltham.manhunt.net": 
	ip => "192.168.1.169",
	ensure => "present", }

host {"maildb06.v4.waltham.manhunt.net": 
	ip => "192.168.1.17",
	ensure => "present", }

host {"mailshard04b.waltham.manhunt.net": 
	ip => "192.168.1.170",
	ensure => "present", }

host {"www31.waltham.manhunt.net": 
	ip => "192.168.1.171",
	ensure => "present", }

host {"www32.waltham.manhunt.net": 
	ip => "192.168.1.172",
	ensure => "present", }

host {"stg-dlistro.waltham.manhunt.net": 
	ip => "192.168.1.173",
	ensure => "present", }

host {"www-i01.waltham.manhunt.net": 
	ip => "192.168.1.174",
	ensure => "present", }

host {"billingf-i01.waltham.manhunt.net": 
	ip => "192.168.1.175",
	ensure => "present", }

host {"billingb-i01.waltham.manhunt.net": 
	ip => "192.168.1.176",
	ensure => "present", }

host {"www33.waltham.manhunt.net": 
	ip => "192.168.1.177",
	ensure => "present", }

host {"www34.waltham.manhunt.net": 
	ip => "192.168.1.178",
	ensure => "present", }

host {"smtp-admin02e.waltham.manhunt.net": 
	ip => "192.168.1.179",
	ensure => "present", }

host {"smtp-onetwo.waltham.manhunt.net": 
	ip => "192.168.1.179",
	ensure => "present", }

host {"smtpd.waltham.manhunt.net": 
	ip => "192.168.1.179",
	ensure => "present", }

host {"smtp01.waltham.manhunt.net": 
	ip => "192.168.1.179",
	ensure => "present", }

host {"maildb07.v4.waltham.manhunt.net": 
	ip => "192.168.1.18",
	ensure => "present", }

host {"monitor1.svc.waltham.manhunt.net": 
	ip => "192.168.1.180",
	ensure => "present", }

host {"syslog1.svc.waltham.manhunt.net": 
	ip => "192.168.1.180",
	ensure => "present", }

host {"monitor2.svc.waltham.manhunt.net": 
	ip => "192.168.1.181",
	ensure => "present", }

host {"syslog2.svc.waltham.manhunt.net": 
	ip => "192.168.1.181",
	ensure => "present", }

host {"db-syslog.svc.waltham.manhunt.net": 
	ip => "192.168.1.182",
	ensure => "present", }

host {"db-gallery.svc.waltham.manhunt.net": 
	ip => "192.168.1.183",
	ensure => "present", }

host {"vmware09.waltham.manhunt.net": 
	ip => "192.168.1.184",
	ensure => "present", }

host {"db-nagios.svc.waltham.manhunt.net": 
	ip => "192.168.1.185",
	ensure => "present", }

host {"db-adsmaster.svc.waltham.manhunt.net": 
	ip => "192.168.1.186",
	ensure => "present", }

host {"bkp-mailshard04.v4.waltham.manhunt.net": 
	ip => "192.168.1.187",
	ensure => "present", }

host {"bkp-mailshard04.waltham.manhunt.net": 
	ip => "192.168.1.187",
	ensure => "present", }

host {"db-ads02.svc.waltham.manhunt.net": 
	ip => "192.168.1.187",
	ensure => "present", }

host {"db-bacula.svc.waltham.manhunt.net": 
	ip => "192.168.1.188",
	ensure => "present", }

host {"sphinxter01.waltham.manhunt.net": 
	ip => "192.168.1.189",
	ensure => "present", }

host {"admindb01.waltham.manhunt.net": 
	ip => "192.168.1.19",
	ensure => "present", }

host {"vmware04.waltham.manhunt.net": 
	ip => "192.168.1.190",
	ensure => "present", }

host {"vmware05.waltham.manhunt.net": 
	ip => "192.168.1.191",
	ensure => "present", }

host {"db-bactyl01.waltham.manhunt.net": 
	ip => "192.168.1.192",
	ensure => "present", }

host {"dbmail-i01.waltham.manhunt.net": 
	ip => "192.168.1.193",
	ensure => "present", }

host {"tera-bactyl03.waltham.manhunt.net": 
	ip => "192.168.1.194",
	ensure => "present", }

host {"dbmail-i02.waltham.manhunt.net": 
	ip => "192.168.1.195",
	ensure => "present", }

host {"isilon00.v4.waltham.manhunt.net": 
	ip => "192.168.1.196",
	ensure => "present", }

host {"isilon00.waltham.manhunt.net": 
	ip => "192.168.1.196",
	ensure => "present", }

host {"isilon01a.v4.waltham.manhunt.net": 
	ip => "192.168.1.197",
	ensure => "present", }

host {"isilon01a.waltham.manhunt.net": 
	ip => "192.168.1.197",
	ensure => "present", }

host {"isilon01b.v4.waltham.manhunt.net": 
	ip => "192.168.1.198",
	ensure => "present", }

host {"isilon01b.waltham.manhunt.net": 
	ip => "192.168.1.198",
	ensure => "present", }

host {"isilon02a.v4.waltham.manhunt.net": 
	ip => "192.168.1.199",
	ensure => "present", }

host {"isilon02a.waltham.manhunt.net": 
	ip => "192.168.1.199",
	ensure => "present", }

host {"mcachemhpd02.wal.manhunt.net": 
	ip => "192.168.1.2",
	ensure => "present", }

host {"reports02.waltham.manhunt.net": 
	ip => "192.168.1.20",
	ensure => "present", }

host {"isilon02b.v4.waltham.manhunt.net": 
	ip => "192.168.1.200",
	ensure => "present", }

host {"isilon02b.waltham.manhunt.net": 
	ip => "192.168.1.200",
	ensure => "present", }

host {"dbtrack-i01.waltham.manhunt.net": 
	ip => "192.168.1.201",
	ensure => "present", }

host {"janusdb01.v4.waltham.manhunt.net": 
	ip => "192.168.1.201",
	ensure => "present", }

host {"maindb03.v4.waltham.manhunt.net": 
	ip => "192.168.1.202",
	ensure => "present", }

host {"db-backup.svc.waltham.manhunt.net": 
	ip => "192.168.1.203",
	ensure => "present", }

host {"mainro11.waltham.manhunt.net": 
	ip => "192.168.1.203",
	ensure => "present", }

host {"mainro13.waltham.manhunt.net": 
	ip => "192.168.1.205",
	ensure => "present", }

host {"mainro14.waltham.manhunt.net": 
	ip => "192.168.1.206",
	ensure => "present", }

host {"presdb00.v4.waltham.manhunt.net": 
	ip => "192.168.1.206",
	ensure => "present", }

host {"trackdb00.v4.waltham.manhunt.net": 
	ip => "192.168.1.207",
	ensure => "present", }

host {"migrate.v4.waltham.manhunt.net": 
	ip => "192.168.1.208",
	ensure => "present", }

host {"dbmail-i03.waltham.manhunt.net": 
	ip => "192.168.1.209",
	ensure => "present", }

host {"kerberos01.waltham.manhunt.net": 
	ip => "192.168.1.21",
	ensure => "present", }

host {"isilon03a.v4.waltham.manhunt.net": 
	ip => "192.168.1.210",
	ensure => "present", }

host {"isilon03a.waltham.manhunt.net": 
	ip => "192.168.1.210",
	ensure => "present", }

host {"isilon03b.v4.waltham.manhunt.net": 
	ip => "192.168.1.211",
	ensure => "present", }

host {"isilon03b.waltham.manhunt.net": 
	ip => "192.168.1.211",
	ensure => "present", }

host {"dbmail-i04.waltham.manhunt.net": 
	ip => "192.168.1.212",
	ensure => "present", }

host {"mainro07.v4.waltham.manhunt.net": 
	ip => "192.168.1.213",
	ensure => "present", }

host {"mainro07.waltham.manhunt.net": 
	ip => "192.168.1.213",
	ensure => "present", }

host {"support01-staging.waltham.manhunt.net": 
	ip => "192.168.1.214",
	ensure => "present", }

host {"support01.waltham.manhunt.net": 
	ip => "192.168.1.214",
	ensure => "present", }

host {"testro01.waltham.manhunt.net": 
	ip => "192.168.1.214",
	ensure => "present", }

host {"mainro09.waltham.manhunt.net": 
	ip => "192.168.1.215",
	ensure => "present", }

host {"maildb09.v4.waltham.manhunt.net": 
	ip => "192.168.1.216",
	ensure => "present", }

host {"admin-staging.v4.waltham.manhunt.net": 
	ip => "192.168.1.217",
	ensure => "present", }

host {"admin00.v4.waltham.manhunt.net": 
	ip => "192.168.1.218",
	ensure => "present", }

host {"wdns01.waltham.manhunt.net": 
	ip => "192.168.1.219",
	ensure => "present", }

host {"reports03.waltham.manhunt.net": 
	ip => "192.168.1.22",
	ensure => "present", }

host {"isilon05a.waltham.manhunt.net": 
	ip => "192.168.1.220",
	ensure => "present", }

host {"isilon05b.waltham.manhunt.net": 
	ip => "192.168.1.221",
	ensure => "present", }

host {"mainro05.v4.waltham.manhunt.net": 
	ip => "192.168.1.221",
	ensure => "present", }

host {"mainro00.v4.waltham.manhunt.net": 
	ip => "192.168.1.222",
	ensure => "present", }

host {"mainro00.waltham.manhunt.net": 
	ip => "192.168.1.222",
	ensure => "present", }

host {"isilon04a.waltham.manhunt.net": 
	ip => "192.168.1.223",
	ensure => "present", }

host {"isilon04b.waltham.manhunt.net": 
	ip => "192.168.1.224",
	ensure => "present", }

host {"itdb04.waltham.manhunt.net": 
	ip => "192.168.1.225",
	ensure => "present", }

host {"admindb02.v4.waltham.manhunt.net": 
	ip => "192.168.1.226",
	ensure => "present", }

host {"cache08.waltham.manhunt.net": 
	ip => "192.168.1.227",
	ensure => "present", }

host {"media04.v4.waltham.manhunt.net": 
	ip => "192.168.1.227",
	ensure => "present", }

host {"tera-bactyl02.waltham.manhunt.net": 
	ip => "192.168.1.228",
	ensure => "present", }

host {"cache06.v4.waltham.manhunt.net": 
	ip => "192.168.1.229",
	ensure => "present", }

host {"mhads01.waltham.manhunt.net": 
	ip => "192.168.1.23",
	ensure => "present", }

host {"stg-mailshard01.v4.waltham.manhunt.net": 
	ip => "192.168.1.230",
	ensure => "present", }

host {"stg-mailshard01.waltham.manhunt.net": 
	ip => "192.168.1.230",
	ensure => "present", }

host {"dick.waltham.manhunt.net": 
	ip => "192.168.1.231",
	ensure => "present", }

host {"cock.waltham.manhunt.net": 
	ip => "192.168.1.232",
	ensure => "present", }

host {"ovulator02b.waltham.manhunt.net": 
	ip => "192.168.1.233",
	ensure => "present", }

host {"sawmill-old.waltham.manhunt.net": 
	ip => "192.168.1.233",
	ensure => "present", }

host {"spare-fl5vgd1.waltham.manhunt.net": 
	ip => "192.168.1.233",
	ensure => "present", }

host {"mainro15.waltham.manhunt.net": 
	ip => "192.168.1.234",
	ensure => "present", }

host {"stg-mailshard02.v4.waltham.manhunt.net": 
	ip => "192.168.1.235",
	ensure => "present", }

host {"stg-mailshard02.waltham.manhunt.net": 
	ip => "192.168.1.235",
	ensure => "present", }

host {"stg-mailshard03.v4.waltham.manhunt.net": 
	ip => "192.168.1.236",
	ensure => "present", }

host {"stg-mailshard03.waltham.manhunt.net": 
	ip => "192.168.1.236",
	ensure => "present", }

host {"stg-mailshard04.v4.waltham.manhunt.net": 
	ip => "192.168.1.237",
	ensure => "present", }

host {"stg-mailshard04.waltham.manhunt.net": 
	ip => "192.168.1.237",
	ensure => "present", }

host {"cache04.v4.waltham.manhunt.net": 
	ip => "192.168.1.238",
	ensure => "present", }

host {"cache05.v4.waltham.manhunt.net": 
	ip => "192.168.1.239",
	ensure => "present", }

host {"dlmdb01.waltham.manhunt.net": 
	ip => "192.168.1.24",
	ensure => "present", }

host {"admin41.v4.waltham.manhunt.net": 
	ip => "192.168.1.241",
	ensure => "present", }

host {"dw03.waltham.manhunt.net": 
	ip => "192.168.1.242",
	ensure => "present", }

host {"mainro08.v4.waltham.manhunt.net": 
	ip => "192.168.1.243",
	ensure => "present", }

host {"mainro08.waltham.manhunt.net": 
	ip => "192.168.1.243",
	ensure => "present", }

host {"mainro06.v4.waltham.manhunt.net": 
	ip => "192.168.1.244",
	ensure => "present", }

host {"mainro06.waltham.manhunt.net": 
	ip => "192.168.1.244",
	ensure => "present", }

host {"maindb01.v4.waltham.manhunt.net": 
	ip => "192.168.1.245",
	ensure => "present", }

host {"mainro01.v4.waltham.manhunt.net": 
	ip => "192.168.1.246",
	ensure => "present", }

host {"mainro01.waltham.manhunt.net": 
	ip => "192.168.1.246",
	ensure => "present", }

host {"ovulator02.waltham.manhunt.net": 
	ip => "192.168.1.248",
	ensure => "present", }

host {"kerberos02.waltham.manhunt.net": 
	ip => "192.168.1.25",
	ensure => "present", }

host {"bkp-openxdb01.waltham.manhunt.net": 
	ip => "192.168.1.26",
	ensure => "present", }

host {"smtp-admin02b.waltham.manhunt.net": 
	ip => "192.168.1.27",
	ensure => "present", }

host {"smtp-twothreefourc.waltham.manhunt.net": 
	ip => "192.168.1.27",
	ensure => "present", }

host {"smtp.waltham.manhunt.net": 
	ip => "192.168.1.27",
	ensure => "present", }

host {"smtp04.waltham.manhunt.net": 
	ip => "192.168.1.27",
	ensure => "present", }

host {"bkp-jpdb.waltham.manhunt.net": 
	ip => "192.168.1.28",
	ensure => "present", }

host {"bkp-jpmail.waltham.manhunt.net": 
	ip => "192.168.1.29",
	ensure => "present", }

host {"mcachemhpd01.wal.manhunt.net": 
	ip => "192.168.1.3",
	ensure => "present", }

host {"dw07.waltham.manhunt.net": 
	ip => "192.168.1.30",
	ensure => "present", }

host {"bkp-mailshard01.v4.waltham.manhunt.net": 
	ip => "192.168.1.31",
	ensure => "present", }

host {"bkp-mailshard01.waltham.manhunt.net": 
	ip => "192.168.1.31",
	ensure => "present", }

host {"billing09.waltham.manhunt.net": 
	ip => "192.168.1.32",
	ensure => "present", }

host {"itdb06.waltham.manhunt.net": 
	ip => "192.168.1.33",
	ensure => "present", }

host {"gallery02.waltham.manhunt.net": 
	ip => "192.168.1.34",
	ensure => "present", }

host {"mhads02.waltham.manhunt.net": 
	ip => "192.168.1.34",
	ensure => "present", }

host {"openxro00.waltham.manhunt.net": 
	ip => "192.168.1.35",
	ensure => "present", }

host {"secure01.waltham.manhunt.net": 
	ip => "192.168.1.35",
	ensure => "present", }

host {"admin01.waltham.manhunt.net": 
	ip => "192.168.1.36",
	ensure => "present", }

host {"jpdb01.waltham.manhunt.net": 
	ip => "192.168.1.36",
	ensure => "present", }

host {"sawmill.waltham.manhunt.net": 
	ip => "192.168.1.37",
	ensure => "present", }

host {"admin02.waltham.manhunt.net": 
	ip => "192.168.1.38",
	ensure => "present", }

host {"www11.v4.waltham.manhunt.net": 
	ip => "192.168.1.39",
	ensure => "present", }

host {"mdbbdpd01.wal.manhunt.net": 
	ip => "192.168.1.4",
	ensure => "present", }

host {"admindb00.v4.waltham.manhunt.net": 
	ip => "192.168.1.40",
	ensure => "present", }

host {"cron02.waltham.manhunt.net": 
	ip => "192.168.1.41",
	ensure => "present", }

host {"ids01.waltham.manhunt.net": 
	ip => "192.168.1.42",
	ensure => "present", }

host {"cache07.waltham.manhunt.net": 
	ip => "192.168.1.43",
	ensure => "present", }

host {"gallery04.waltham.manhunt.net": 
	ip => "192.168.1.44",
	ensure => "present", }

host {"maildb08.v4.waltham.manhunt.net": 
	ip => "192.168.1.45",
	ensure => "present", }

host {"bkp-mailshard02.v4.waltham.manhunt.net": 
	ip => "192.168.1.46",
	ensure => "present", }

host {"bkp-mailshard02.waltham.manhunt.net": 
	ip => "192.168.1.46",
	ensure => "present", }

host {"billing01.v4.waltham.manhunt.net": 
	ip => "192.168.1.47",
	ensure => "present", }

host {"billing02.v4.waltham.manhunt.net": 
	ip => "192.168.1.48",
	ensure => "present", }

host {"smartfox01.waltham.manhunt.net": 
	ip => "192.168.1.49",
	ensure => "present", }

host {"sdbbdpd01.wal.manhunt.net": 
	ip => "192.168.1.5",
	ensure => "present", }

host {"db-bactyl02.waltham.manhunt.net": 
	ip => "192.168.1.50",
	ensure => "present", }

host {"itvmwin05.waltham.manhunt.net": 
	ip => "192.168.1.51",
	ensure => "present", }

host {"mainsflp00.waltham.manhunt.net": 
	ip => "192.168.1.52",
	ensure => "present", }

host {"jpmaildb02.waltham.manhunt.net": 
	ip => "192.168.1.53",
	ensure => "present", }

host {"japan01.waltham.manhunt.net": 
	ip => "192.168.1.54",
	ensure => "present", }

host {"japan02.waltham.manhunt.net": 
	ip => "192.168.1.55",
	ensure => "present", }

host {"jpmaildb01.waltham.manhunt.net": 
	ip => "192.168.1.56",
	ensure => "present", }

host {"smartfox02.waltham.manhunt.net": 
	ip => "192.168.1.57",
	ensure => "present", }

host {"jpdb02.waltham.manhunt.net": 
	ip => "192.168.1.58",
	ensure => "present", }

host {"japan03.waltham.manhunt.net": 
	ip => "192.168.1.59",
	ensure => "present", }

host {"jpdb03.waltham.manhunt.net": 
	ip => "192.168.1.59",
	ensure => "present", }

host {"sdbbdpd02.wal.manhunt.net": 
	ip => "192.168.1.6",
	ensure => "present", }

host {"myna.waltham.manhunt.net": 
	ip => "192.168.1.60",
	ensure => "present", }

host {"smartfox03.waltham.manhunt.net": 
	ip => "192.168.1.61",
	ensure => "present", }

host {"mhads05.waltham.manhunt.net": 
	ip => "192.168.1.62",
	ensure => "present", }

host {"mhads03.waltham.manhunt.net": 
	ip => "192.168.1.63",
	ensure => "present", }

host {"mhads04.waltham.manhunt.net": 
	ip => "192.168.1.64",
	ensure => "present", }

host {"openxadm01.waltham.manhunt.net": 
	ip => "192.168.1.65",
	ensure => "present", }

host {"openxadm03b.waltham.manhunt.net": 
	ip => "192.168.1.65",
	ensure => "present", }

host {"dlsdb00.waltham.manhunt.net": 
	ip => "192.168.1.66",
	ensure => "present", }

host {"bkp-mailshard03.v4.waltham.manhunt.net": 
	ip => "192.168.1.67",
	ensure => "present", }

host {"bkp-mailshard03.waltham.manhunt.net": 
	ip => "192.168.1.67",
	ensure => "present", }

host {"starling.waltham.manhunt.net": 
	ip => "192.168.1.68",
	ensure => "present", }

host {"dwpres.v4.waltham.manhunt.net": 
	ip => "192.168.1.69",
	ensure => "present", }

host {"wwwbdpd01.wal.manhunt.net": 
	ip => "192.168.1.7",
	ensure => "present", }

host {"cache02.waltham.manhunt.net": 
	ip => "192.168.1.70",
	ensure => "present", }

host {"mgate01.waltham.manhunt.net": 
	ip => "192.168.1.71",
	ensure => "present", }

host {"decomm-mgate02.waltham.manhunt.net": 
	ip => "192.168.1.72",
	ensure => "present", }

host {"mgate02.waltham.manhunt.net": 
	ip => "192.168.1.72",
	ensure => "present", }

host {"mainro12.waltham.manhunt.net": 
	ip => "192.168.1.73",
	ensure => "present", }

host {"dlsdb01.waltham.manhunt.net": 
	ip => "192.168.1.74",
	ensure => "present", }

host {"db02.waltham.manhunt.net": 
	ip => "192.168.1.75",
	ensure => "present", }

host {"dlsdb02.waltham.manhunt.net": 
	ip => "192.168.1.75",
	ensure => "present", }

host {"www01.v4.waltham.manhunt.net": 
	ip => "192.168.1.76",
	ensure => "present", }

host {"www02.v4.waltham.manhunt.net": 
	ip => "192.168.1.77",
	ensure => "present", }

host {"www03.v4.waltham.manhunt.net": 
	ip => "192.168.1.78",
	ensure => "present", }

host {"www04.v4.waltham.manhunt.net": 
	ip => "192.168.1.79",
	ensure => "present", }

host {"wwwbdpd02.wal.manhunt.net": 
	ip => "192.168.1.8",
	ensure => "present", }

host {"www05.v4.waltham.manhunt.net": 
	ip => "192.168.1.80",
	ensure => "present", }

host {"www06.v4.waltham.manhunt.net": 
	ip => "192.168.1.81",
	ensure => "present", }

host {"www07.v4.waltham.manhunt.net": 
	ip => "192.168.1.82",
	ensure => "present", }

host {"www08.v4.waltham.manhunt.net": 
	ip => "192.168.1.83",
	ensure => "present", }

host {"www09.v4.waltham.manhunt.net": 
	ip => "192.168.1.84",
	ensure => "present", }

host {"www10.v4.waltham.manhunt.net": 
	ip => "192.168.1.85",
	ensure => "present", }

host {"cache03.v4.waltham.manhunt.net": 
	ip => "192.168.1.86",
	ensure => "present", }

host {"www12.v4.waltham.manhunt.net": 
	ip => "192.168.1.87",
	ensure => "present", }

host {"trackdb01.waltham.manhunt.net": 
	ip => "192.168.1.88",
	ensure => "present", }

host {"billing06.waltham.manhunt.net": 
	ip => "192.168.1.89",
	ensure => "present", }

host {"openxadm02.waltham.manhunt.net": 
	ip => "192.168.1.90",
	ensure => "present", }

host {"dbadsro03.waltham.manhunt.net": 
	ip => "192.168.1.91",
	ensure => "present", }

host {"chatperf01.waltham.manhunt.net": 
	ip => "192.168.1.92",
	ensure => "present", }

host {"mainbk01.waltham.manhunt.net": 
	ip => "192.168.1.92",
	ensure => "present", }

host {"testro03.waltham.manhunt.net": 
	ip => "192.168.1.92",
	ensure => "present", }

host {"dlsdb03.waltham.manhunt.net": 
	ip => "192.168.1.93",
	ensure => "present", }

host {"www28.waltham.manhunt.net": 
	ip => "192.168.1.94",
	ensure => "present", }

host {"edns01.waltham.manhunt.net": 
	ip => "192.168.1.95",
	ensure => "present", }

host {"www29.v4.waltham.manhunt.net": 
	ip => "192.168.1.96",
	ensure => "present", }

host {"www29.waltham.manhunt.net": 
	ip => "192.168.1.96",
	ensure => "present", }

host {"www30.v4.waltham.manhunt.net": 
	ip => "192.168.1.97",
	ensure => "present", }

host {"www30.waltham.manhunt.net": 
	ip => "192.168.1.97",
	ensure => "present", }

host {"admin-i01.waltham.manhunt.net": 
	ip => "192.168.1.98",
	ensure => "present", }

host {"dbads01.waltham.manhunt.net": 
	ip => "192.168.1.99",
	ensure => "present", }

host {"www10-old6850.v4.waltham.manhunt.net": 
	ip => "192.168.99.85",
	ensure => "present", }

}#end of hosts::waltham
