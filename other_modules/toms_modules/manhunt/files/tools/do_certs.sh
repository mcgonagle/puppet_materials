#!/bin/bash
#
# $Id: do_certs.sh,v 1.3 2009/01/28 21:03:15 wflynn Exp $
#
# do_certs.sh: Script to automate generation of keys, certificate requests, and self-signed certificates.
#
# Created by wflynn 01/09
#
#

EXPECTED_ARGS=2
TMPDIR=/tmp
ORGDOMAIN="manhunt.net"

if [ $# -ne $EXPECTED_ARGS ]
then
    echo "Usage: `basename $0` CommonName CertName "
    echo -e "Example: `basename $0` foobar.manhunt.net bazbang"
    echo -e "\tCreates password-free key:"
    echo -e "\t\t'bazbang.${ORGDOMAIN}.key'"
    echo -e "\tAnd certificate request:" 
    echo -e "\t\t'bazbang.${ORGDOMAIN}.csr'"
    echo -e "\tAnd self-signed certificate:" 
    echo -e "\t\t'bazbang.${ORGDOMAIN}.crt'"
    echo -e "\tFor the server to be accessed via:" 
    echo -e "\t\t'https://foobar.manhunt.net/'" 
    exit;
fi

COMMONNAME=$1
CERTNAME=$2

FILEDIR=${TMPDIR}/${ORGDOMAIN}/${CERTNAME}
SIGNED_KEY=${CERTNAME}.${ORGDOMAIN}.signed.key
CLEAR_KEY=${CERTNAME}.${ORGDOMAIN}.key
CERT_REQUEST=${CERTNAME}.${ORGDOMAIN}.csr
SELF_SIGNED_CERT=${CERTNAME}.${ORGDOMAIN}.crt

mkdir -p ${FILEDIR}
cd ${FILEDIR}

echo "Your files will be in ${FILEDIR}"
echo "Generating signed key..."
openssl genrsa -passout pass:${CERTNAME} -des3 -out ${SIGNED_KEY} 1024
echo "Generating certificate request. This will be printed at the end to present to a Certificate Authority..."
openssl req -passin pass:${CERTNAME} -new -key ${SIGNED_KEY} -out ${CERT_REQUEST} -subj /CN=${COMMONNAME}/OU="Online Buddies"/O="Online Buddies, Inc."/L=Cambridge/ST=MA/C=US
echo "Swapping signed key for clear key..."
openssl rsa -passin pass:${CERTNAME} -in ${SIGNED_KEY} -out ${CLEAR_KEY} && rm -f ${SIGNED_KEY}
echo "Generating self-signed Certificate (Expires in 1 year)..."
openssl x509 -req -days 365 -in ${CERT_REQUEST} -signkey ${CLEAR_KEY} -out ${SELF_SIGNED_CERT}
echo ""

ls -l ${CLEAR_KEY} ${CERT_REQUEST} ${SELF_SIGNED_CERT}

echo ""

openssl req -text < ${CERT_REQUEST}

