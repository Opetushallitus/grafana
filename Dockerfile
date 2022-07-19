FROM grafana/grafana:9.0.3
USER root
RUN apk add --update nodejs npm curl
USER grafana
COPY run_proxy_and_grafana.sh /
COPY --chown=grafana:root grafana_proxy /grafana_proxy
RUN npm i -C /grafana_proxy
RUN grafana-cli plugins install camptocamp-prometheus-alertmanager-datasource && \
    grafana-cli plugins install ryantxu-ajax-panel
COPY grafana_setup.sh /
COPY --chown=grafana:root dashboard /etc/grafana/dashboard
COPY --chown=grafana:root user /etc/grafana/user
COPY --chown=grafana:root datasource /etc/grafana/datasource
ENTRYPOINT ["/run_proxy_and_grafana.sh"]
