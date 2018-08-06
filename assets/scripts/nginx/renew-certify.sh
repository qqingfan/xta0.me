#!/bin/bash

web_service='nginx'
config_file="/usr/local/etc/le-renew-webroot.ini"

le_path='/opt/letsencrypt'
exp_limit=30;

if [ ! -f $config_file ]; then
        echo "[ERROR] config file does not exist: $config_file"
        exit 1;
fi

# domain=`grep "^\s*domains" $config_file | sed "s/^\s*domains\s*=\s*//" | sed 's/(\s*)\|,.*$//'`
domain='xta0.me'
cert_file="/etc/letsencrypt/live/$domain/fullchain.pem"

if [ ! -f $cert_file ]; then
	echo "[ERROR] certificate file not found for domain $domain."
fi

exp=$(date -d "`openssl x509 -in $cert_file -text -noout|grep "Not After"|cut -c 25-`" +%s)
datenow=$(date -d "now" +%s)
days_exp=$(echo \( $exp - $datenow \) / 86400 |bc)

echo "Checking expiration date for $domain..."

if [ "$days_exp" -gt "$exp_limit" ] ; then
	echo "The certificate is up to date, no need for renewal ($days_exp days left)."
	exit 0;
else
	echo "The certificate for $domain is about to expire soon. Starting webroot renewal script..."
        $le_path/letsencrypt-auto certonly -a webroot --agree-tos --renew-by-default --config $config_file
	echo "Reloading $web_service"
	/usr/sbin/service $web_service reload
	echo "Renewal process finished for domain $domain"
	exit 0;