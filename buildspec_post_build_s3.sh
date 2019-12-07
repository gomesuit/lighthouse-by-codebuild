#!/bin/bash -eu

function copy_to_s3 () {
  DOMAIN=$1
  CATEGORY=$2
  DEVICE=$3

  aws s3 cp \
    "./outputs/$DOMAIN/$DEVICE/$CATEGORY/converted.report.json" \
    "s3://$S3_BUCKET/json/domain=$DOMAIN/device=$DEVICE/category=$CATEGORY/year=$YEAR/month=$MONTH/day=$DAY/hour=$HOUR/minute=$MINUTE/"

  aws s3 cp \
    "./outputs/$DOMAIN/$DEVICE/$CATEGORY/output.report.json" \
    "s3://$S3_BUCKET/html/$DOMAIN/$DEVICE/$CATEGORY/$YEAR/$MONTH/$DAY/$HOUR/$MINUTE/"

  aws s3 cp \
    "./outputs/$DOMAIN/$DEVICE/$CATEGORY/output.report.html" \
    "s3://$S3_BUCKET/html/$DOMAIN/$DEVICE/$CATEGORY/$YEAR/$MONTH/$DAY/$HOUR/$MINUTE/"
}

while read -r row; do
  domain=$(echo "$row" | awk -F, '{ print $1 }')
  category=$(echo "$row" | awk -F, '{ print $3 }')
  copy_to_s3 "$domain" "$category" mobile
  copy_to_s3 "$domain" "$category" desktop
done < urls.csv
