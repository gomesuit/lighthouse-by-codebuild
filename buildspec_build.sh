#!/bin/bash -eu

function exec_lighthouse () {
  DOMAIN=$1
  TARGET_URL=$2
  CATEGORY=$3
  DEVICE=$4

  echo "DOMAIN: $DOMAIN"
  echo "URL: $TARGET_URL"
  echo "CATEGORY: $CATEGORY"
  echo "DEVICE: $DEVICE"

  mkdir -p "outputs/$DOMAIN/$DEVICE/$CATEGORY"

  lighthouse "$TARGET_URL" \
    --config-path "./lighthouse-$DEVICE-config.js" \
    --port=9222 \
    --chrome-flags="--headless" \
    --output json \
    --output html \
    --output-path "./outputs/$DOMAIN/$DEVICE/$CATEGORY/output"

  jq '. + {metrics: .audits.metrics} | del(.i18n, .audits)' -c \
    "outputs/$DOMAIN/$DEVICE/$CATEGORY/output.report.json" \
    > "outputs/$DOMAIN/$DEVICE/$CATEGORY/converted.report.json"
}

while read -r row; do
  domain=$(echo "$row" | awk -F, '{ print $1 }')
  url=$(echo "$row" | awk -F, '{ print $2 }')
  category=$(echo "$row" | awk -F, '{ print $3 }')
  exec_lighthouse "$domain" "$url" "$category" mobile
  exec_lighthouse "$domain" "$url" "$category" desktop
done < urls.csv
