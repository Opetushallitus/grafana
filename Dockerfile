FROM grafana/grafana:6.6.2-ubuntu
USER root
RUN apt-get update
RUN apt-get -y install curl gnupg
RUN curl -sL https://deb.nodesource.com/setup_12.x  | bash -
RUN apt-get -y install nodejs
RUN apt-get clean
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
