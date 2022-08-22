FROM changingai/go-jsonnet:latest

USER root

COPY . /data/grafana

RUN chown -R 11160:11160 /data && chmod -R 755 /data

USER 11160

RUN jb update .
