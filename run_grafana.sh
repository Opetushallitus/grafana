#!/bin/bash
set -m

/run.sh &

sleep 30
/grafana_setup.sh

fg %1