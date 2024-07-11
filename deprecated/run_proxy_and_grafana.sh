#!/bin/sh

/run.sh & \
node /grafana_proxy/proxy.js & \
timeout -s TERM 60 bash -c \
'while [[ "$(curl -s -o /dev/null -L -w ''%{http_code}'' ${0})" != "200" ]];\
do echo "Waiting for Grafana to respond..." && sleep 5;
done; echo "Grafana is ready, proceeding..."' http://localhost:3000 && \
/grafana_setup.sh

while sleep 60; do
  ps aux |grep grafana-server |grep -q -v grep
  GRAFANA_STATUS=$?
  ps aux |grep proxy.js |grep -q -v grep
  GRAFANA_PROXY_STATUS=$?
  if [ $GRAFANA_STATUS -ne 0 -o $GRAFANA_PROXY_STATUS -ne 0 ]; then
    echo "Either Grafana or Grafana Pingdom API proxy has crashed.."
    exit 1
  fi
done
