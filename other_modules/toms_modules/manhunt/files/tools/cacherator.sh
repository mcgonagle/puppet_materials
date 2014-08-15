#!/bin/bash -X
#
# cacherator.sh
#
# $Id: cacherator.sh,v 1.10 2010/10/14 20:07:30 apradhan Exp $
#
# WFlynn 03/09
#
# Stupid script for resetting caches to commit a release
#

ENVIRONMENT=${1}
FELIST=(
    www01
    www02
    www03
    www04
    www06
    www07
    www08
    www09
    www10
    www13
    www14
    www15
    www16
    www17
    www18
    www19
    www20
    www21
    www22
    www23
    www24
    www25
    www26
    www27
    www28
    www31
    www32
)

BILLINGLIST=(
    billing01
    billing02
    billing03
    billing06
)

ADMINLIST=(
    admin41
)

STGFELIST=(
    www05
    www-i01
)

STGBILLINGLIST=(
    billing04
    billing05
)

STGADMINLIST=(
    admin42
)

#  REAL YOR
YOR="\\033[0;1m\\033[m\\033[1;33;41m\\c"
YOG="\\033[0;1m\\033[m\\033[1;33;42m\\c"
NYOR="\\033[1m\\033[m\\n"

#WGET="/usr/bin/lynx -dump -accept_all_cookies"
WGET="/usr/bin/wget  --max-redirect=0 --no-check-certificate -q -O-"
WGETQ="/usr/bin/wget  --max-redirect=0 --no-check-certificate -q -O /dev/null"
LYNX="/usr/bin/lynx -dump --force-html -stdin"
CCHK="grep -q Cleared"

bounce_memcache() {
    HOSTLIST=( `echo "$@"` )
    for HOST in ${HOSTLIST[*]}
    do
	echo "Memcaches Trying: ${HOST}..."
	TURL="http://${HOST}.v4.waltham.manhunt.net/debuginfobasic.php"
	# echo "${TURL}"
	if ${WGETQ} ${TURL}
	then
	    echo "${HOST} appears up.  Clearing memcaches..."
	    GURL="http://${HOST}.v4.waltham.manhunt.net/index.php/user/genMemclear/pass/w74byru4r416dfphj7jm2f"
	    EURL="http://${HOST}.v4.waltham.manhunt.net/index.php/user/entMemclear/pass/w74byru4r416dfphj7jm2f"
	    # echo "Trying: ${GURL}"
	    if ${WGET} ${GURL} | ${LYNX} | ${CCHK}
	    then 
		echo -e ${YOG}
		echo -e "${HOST} General Memcache Cleared...\\c"
		echo -e ${NYOR}
		# echo "Trying: ${EURL}"
		if ${WGET} ${EURL} | ${LYNX} | ${CCHK}
		then
		    echo -e ${YOG}
		    echo -e "${HOST} Entitlements Memcache Cleared...\\c"
		    echo -e ${NYOR}
		    return
		else
		    continue
		fi
	    else
		continue
	    fi
	else
	    echo "Memcaches: ${HOST} Not up!"
	    continue
	fi
	echo -e ${NYOR}
    done
    ## FALL THROUGH
    echo -e ${YOR}
    echo -e "\n\nMEMCACHES NOT CLEARED!\n\nI COULDN'T REACH A WEBHEAD IN ${ENVIRONMENT}!\n\nDID YOU FUCK SOMETHING UP?\n\n\\c"
    echo -e ${NYOR}
}

bounce_apccache () {
    AHOST=$1
    AURL=$2
    if ${WGET} ${AURL} | ${LYNX} | ${CCHK}
    then
	echo -e ${YOG}
	echo -e "\aAPC CACHE ON ${AHOST} CLEARED\\c"
	echo -e ${NYOR}
    else
	echo -e ${YOR}
	echo -e "\aAPC CACHE ON ${AHOST} NOT CLEARED\\c"
	echo -e ${NYOR}
    fi
}

case "${ENVIRONMENT}" in
    PRODUCTION)
	# FIRST PASS
	for HOST in ${FELIST[*]}
	do
	    echo "${HOST}..."
	    URL="http://${HOST}.v4.waltham.manhunt.net/user/apcClear/pass/w74byru4r416dfphj7jm2f"
	    # echo "${URL}"
	    bounce_apccache ${HOST} ${URL}
	done
	for HOST in ${BILLINGLIST[*]}
	do
	    echo "${HOST}..."
	    URL="https://${HOST}.v4.waltham.manhunt.net/user/apcClear/pass/w74byru4r416dfphj7jm2f"
	    # echo "${URL}"
	    bounce_apccache ${HOST} ${URL}
	done
	for HOST in ${ADMINLIST[*]}
	do
	    echo "${HOST}..."
	    URL="https://${HOST}.v4.waltham.manhunt.net/admin.php/home/apcClear/pass/w74byru4r416dfphj7jm2f"
	    # echo "${URL}"
	    bounce_apccache ${HOST} ${URL}
	done
	# MEMCACHES
	bounce_memcache `echo ${FELIST[@]}`
	# SECOND PASS
	for HOST in ${FELIST[*]}
	do
	    echo "${HOST}..."
	    URL="http://${HOST}.v4.waltham.manhunt.net/user/apcClear/pass/w74byru4r416dfphj7jm2f"
	    # echo "${URL}"
	    bounce_apccache ${HOST} ${URL}
	done
	for HOST in ${BILLINGLIST[*]}
	do
	    echo "${HOST}..."
	    URL="https://${HOST}.v4.waltham.manhunt.net/user/apcClear/pass/w74byru4r416dfphj7jm2f"
	    # echo "${URL}"
	    bounce_apccache ${HOST} ${URL}
	done
	for HOST in ${ADMINLIST[*]}
	do
	    echo "${HOST}..."
	    URL="https://${HOST}.v4.waltham.manhunt.net/admin.php/home/apcClear/pass/w74byru4r416dfphj7jm2f"
	    # echo "${URL}"
	    bounce_apccache ${HOST} ${URL}
	done
	;;
    STAGING)
	# FIRST PASS
	for HOST in ${STGFELIST[*]}
	do
	    echo "${HOST}..."
	    URL="http://${HOST}.v4.waltham.manhunt.net/user/apcClear/pass/w74byru4r416dfphj7jm2f"
	    # echo "${URL}"
	    bounce_apccache ${HOST} ${URL}
	done
	for HOST in ${STGBILLINGLIST[*]}
	do
	    echo "${HOST}..."
	    URL="https://${HOST}.v4.waltham.manhunt.net/user/apcClear/pass/w74byru4r416dfphj7jm2f"
	    # echo "${URL}"
	    bounce_apccache ${HOST} ${URL}
	done
	for HOST in ${STGADMINLIST[*]}
	do
	    echo "${HOST}..."
	    URL="https://${HOST}.v4.waltham.manhunt.net/admin.php/home/apcClear/pass/w74byru4r416dfphj7jm2f"
	    # echo "${URL}"
	    bounce_apccache ${HOST} ${URL}
	done
	# MEMCACHES
	bounce_memcache `echo ${STGFELIST[@]}`
	# SECOND PASS
	for HOST in ${STGFELIST[*]}
	do
	    echo "${HOST}..."
	    URL="http://${HOST}.v4.waltham.manhunt.net/user/apcClear/pass/w74byru4r416dfphj7jm2f"
	    # echo "${URL}"
	    bounce_apccache ${HOST} ${URL}
	done
	for HOST in ${STGBILLINGLIST[*]}
	do
	    echo "${HOST}..."
	    URL="https://${HOST}.v4.waltham.manhunt.net/user/apcClear/pass/w74byru4r416dfphj7jm2f"
	    # echo "${URL}"
	    bounce_apccache ${HOST} ${URL}
	done
	for HOST in ${STGADMINLIST[*]}
	do
	    echo "${HOST}..."
	    URL="https://${HOST}.v4.waltham.manhunt.net/admin.php/home/apcClear/pass/w74byru4r416dfphj7jm2f"
	    # echo "${URL}"
	    bounce_apccache ${HOST} ${URL}
	done
	;;
    *)
	echo "Unknown argument: ${ENVIRONMENT}" && echo "Usage: $0 ENVIRONMENT" && exit
	;;
esac
