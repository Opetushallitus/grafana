# Grafana

![Travis status](https://api.travis-ci.org/Opetushallitus/grafana.svg?branch=master)

A Docker image for Grafana and a proxy for Pingdom API. Includes creation of datasources, dashboards.
Base image from [grafana-docker](https://github.com/Opetushallitus/clamav-rest).

Includes a small proxy to help with CORS issues related to Pingdom API.

## Testing

You can test the build locally on your machine by running:

    docker build -t grafana:latest .
