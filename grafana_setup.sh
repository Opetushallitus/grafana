#!/bin/bash

echo "Setting admin password..."
curl -X PUT  -H "Content-Type: application/json" -d "{ \"oldPassword\": \"admin\", \"newPassword\":\"$GRAFANA_ADMIN_PASSWORD\", \"confirmNew\":\"$GRAFANA_ADMIN_PASSWORD\" }" http://admin:admin@localhost:3000/api/user/password

echo "Editing dashboards..."
sed -i -e "s/ENVIRONMENT/${ENVIRONMENT_NAME}/g" /var/lib/grafana/dashboards/*
sed -i -e "s/REGION/${AWS_REGION}/g" /var/lib/grafana/dashboards/*
