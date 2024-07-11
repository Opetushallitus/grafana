FROM grafana/grafana-oss:11.1.0
USER root
RUN apk add --update curl bash
USER grafana
COPY run_grafana.sh grafana_setup.sh /
COPY --chown=grafana:root datasource /etc/grafana/datasource
COPY --chown=grafana:root dashboards /var/lib/grafana/dashboards
COPY --chown=grafana:root provisioning /etc/grafana/provisioning
ENTRYPOINT ["/run_grafana.sh"]
