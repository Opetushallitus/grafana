FROM grafana/grafana:6.6.0
USER root
RUN apk add --update nodejs npm curl
USER grafana
COPY run_proxy_and_grafana.sh /
COPY --chown=grafana:grafana grafana_proxy /grafana_proxy
RUN npm i -C /grafana_proxy
RUN grafana-cli plugins install camptocamp-prometheus-alertmanager-datasource && \
    grafana-cli plugins install ryantxu-ajax-panel
COPY grafana_setup.sh /
COPY --chown=grafana:grafana dashboard /etc/grafana/dashboard
COPY --chown=grafana:grafana user /etc/grafana/user
COPY --chown=grafana:grafana datasource /etc/grafana/datasource
ENTRYPOINT ["/run_proxy_and_grafana.sh"]
