#!/bin/sh

echo "Setting admin password..."
curl -s -H "Content-Type: application/json" --request PUT --data "{ \"password\":\"$GRAFANA_ADMIN_PASSWORD\" }" http://admin:admin@localhost:3000/api/admin/users/1/password

echo "Creating dashboards..."
sed -i -e "s/ENVIRONMENT/${ENVIRONMENT_NAME}/g" /etc/grafana/dashboard/*
sed -i -e "s/PUBLICHOSTEDZONE/${PUBLIC_HOSTED_ZONE}/g" /etc/grafana/dashboard/*
sed -i -e "s/REGION/${AWS_REGION}/g" /etc/grafana/dashboard/*
sed -i -e "s/PINGDOMAPIAUTHHEADER/$PINGDOM_API_AUTH_HEADER/g" /etc/grafana/dashboard/*
sed -i -e "s/PINGDOMAPIKEY/$PINGDOM_APIKEY/g" /etc/grafana/dashboard/*
sed -i -e "s/PINGDOMACCOUNTEMAIL/$PINGDOM_ACCOUNT_EMAIL/g" /etc/grafana/dashboard/*

for i in `ls /etc/grafana/dashboard/*.json`; do
  echo "Creating $i..."
  curl -s -H "Content-Type: application/json" --request POST --data @$i \
    http://admin:$GRAFANA_ADMIN_PASSWORD@localhost:3000/api/dashboards/db
done
