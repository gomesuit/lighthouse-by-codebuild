#!/bin/bash -eu

function create_partition () {
  DOMAIN=$1
  CATEGORY=$2
  DEVICE=$3

  SQL="""
  ALTER TABLE
    $ATHENA_DATABASE.$ATHENA_TABLE
  ADD IF NOT EXISTS PARTITION (
    domain = '$DOMAIN',
    device = '$DEVICE',
    category = '$CATEGORY',
    year = '$YEAR',
    month = '$MONTH',
    day = '$DAY',
    hour = '$HOUR',
    minute = '$MINUTE'
  )
  LOCATION
    's3://$S3_BUCKET/json/domain=$DOMAIN/device=$DEVICE/category=$CATEGORY/year=$YEAR/month=$MONTH/day=$DAY/hour=$HOUR/minute=$MINUTE';
  """

  echo "$SQL"

  output_location="s3://$S3_BUCKET_RESULT/"

  aws athena start-query-execution \
    --result-configuration "OutputLocation=$output_location" \
    --query-string "$SQL"
}

while read -r row; do
  domain=$(echo "$row" | awk -F, '{ print $1 }')
  category=$(echo "$row" | awk -F, '{ print $3 }')
  create_partition "$domain" "$category" mobile
  create_partition "$domain" "$category" desktop
done < urls.csv
