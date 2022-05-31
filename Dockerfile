FROM mdawar/rq-exporter:latest

USER root

RUN apt update && apt install jq -y

COPY docker-entrypoint.sh docker-entrypoint.sh 
RUN chmod +x docker-entrypoint.sh

USER 999

ENTRYPOINT ["./docker-entrypoint.sh"]
