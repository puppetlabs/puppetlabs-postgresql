#!/bin/bash
set -x

DATADIR=$1
USER=$2
GROUP=$3
SUBJECT=$4
DAYS=$5
FORCE=$6
FORCE+=0

if [[ "$FORCE" -eq 1 ]]
then
  [ -f "$DATADIR/server.key" ] && /bin/rm "$DATADIR/server.key"
  [ -f "$DATADIR/server.crt" ] && /bin/rm "$DATADIR/server.crt"
  [ -f "$DATADIR/root.crt" ] && /bin/rm "$DATADIR/root.crt"
fi

/usr/bin/openssl genrsa -des3 -passout pass:puppetlabs-postgresql -out "$DATADIR/server.key" 1024
/usr/bin/openssl rsa -passin pass:puppetlabs-postgresql -in "$DATADIR/server.key" -out "$DATADIR/server.key" 
/usr/bin/openssl req -new -key "$DATADIR/server.key" -days "$DAYS" -out "$DATADIR/server.crt" -x509 -subj "$SUBJECT" 
/bin/chown "$USER:$GROUP" "$DATADIR/server.key"
/bin/chmod 0400 "$DATADIR/server.key"
/bin/cp "$DATADIR/server.crt" "$DATADIR/root.crt"

EXIT_CODE=`$DATADIR/validate_self_signed_ssl_certificate.pl -p $DATADIR -s "$SUBJECT" -d $DAYS`
exit $EXIT_CODE 

# Contributed by Hugh Esco <hesco@yourmessagedelivered.com>
# YMD Partners LLC
# to the puppetlabs-postgresql module
# https://github.com/hesco/puppetlabs-postgresql#class-postgresqlserverssl_certificate 

