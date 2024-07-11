#!/bin/bash
set -m

/run.sh &

sleep 15
/grafana_setup.sh

fg %1