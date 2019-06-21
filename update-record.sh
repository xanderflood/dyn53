#!/bin/bash

set -e

# hostname should already be defined
hosted_zone_id=`cat /run/secrets/hosted_zone_id`
public_ip_address="$(dig +short myip.opendns.com @resolver1.opendns.com)"

aws route53 change-resource-record-sets --hosted-zone-id="$hosted_zone_id" --change-batch="{
  \"Comment\": \"string\",
  \"Changes\": [
    {
      \"Action\": \"UPSERT\",
      \"ResourceRecordSet\": {
        \"Name\": \"$hostname\",
        \"Type\": \"A\",
        \"TTL\": 300,
        \"ResourceRecords\": [
          {
            \"Value\": \"$public_ip_address\"
          }
        ]
      }
    }
  ]
}"

