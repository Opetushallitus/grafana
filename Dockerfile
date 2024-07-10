FROM grafana/grafana-oss:11.1.0
USER root
RUN apk add --update nodejs npm curl
USER grafana
COPY run_proxy_and_grafana.sh /
COPY --chown=grafana:root grafana_proxy /grafana_proxy
RUN npm i -C /grafana_proxy
RUN grafana cli plugins install ryantxu-ajax-panel
COPY grafana_setup.sh /
COPY --chown=grafana:root dashboard /etc/grafana/dashboard
COPY --chown=grafana:root user /etc/grafana/user
COPY --chown=grafana:root provisioning /etc/grafana/provisioning
ENTRYPOINT ["/run_proxy_and_grafana.sh"]
