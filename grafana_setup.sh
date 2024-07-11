#!/bin/bash

echo "Setting admin password..."
curl -s -X PUT -H "Content-Type: application/json" -d "{ \"oldPassword\": \"admin\", \"newPassword\":\"$GRAFANA_ADMIN_PASSWORD\", \"confirmNew\":\"$GRAFANA_ADMIN_PASSWORD\" }" http://admin:admin@localhost:3000/api/user/password

echo "Editing data sources..."
sed -i -e "s/PROMETHEUS_URL/${PROMETHEUS_URL}/g" /etc/grafana/datasource/*
for i in `ls /etc/grafana/datasource/*.json`; do
  echo "Creating $i..."
  curl -s -H "Content-Type: application/json" --request POST --data @$i \
    http://admin:$GRAFANA_ADMIN_PASSWORD@localhost:3000/api/datasources
done

echo "Editing dashboards..."
sed -i -e "s/ENVIRONMENT/${ENVIRONMENT_NAME}/g" /var/lib/grafana/dashboards/*
sed -i -e "s/REGION/${AWS_REGION}/g" /var/lib/grafana/dashboards/*
