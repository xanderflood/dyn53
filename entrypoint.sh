#!/bin/sh

AWS_ACCESS_KEY_ID=`cat /run/secrets/aws_access_key_id`
AWS_SECRET_ACCESS_KEY=`cat /run/secrets/aws_secret_access_key`

# no idea why this is necessary, but AWS seems not to be able to see my credentials
mkdir /root/.aws
echo "[default]
aws_access_key_id=$AWS_ACCESS_KEY_ID
aws_secret_access_key=$AWS_SECRET_ACCESS_KEY
" > /root/.aws/credentials

echo "
# m h  dom mon dow   command
*/30 * * * * hostname=\"$HOSTNAME\" hosted_zone_id=\"$HOSTED_ZONE_ID\" . /update-record.sh >> /var/log/dyn53.log
" > /crontab.txt

/usr/bin/crontab /crontab.txt

# start cron
/usr/sbin/crond -f -l 8

