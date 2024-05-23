#!/bin/bash

# Set env vars and display results.
if ! [[ -z $VCAP_SERVICES ]]; then
  echo "Setting --redis-url exporter arg to \$VCAP_SERVICES.redis.credentials.uri value (private)."
  RQ_REDIS_URL_ARG="--redis-url $(echo $VCAP_SERVICES | jq .redis[].credentials.uri -r)"
else
  echo "\$VCAP_SERVICES env var not set. \$RQ_REDIS_URL (if set) will be used by the exporter."
  if [[ -z $RQ_REDIS_URL ]]; then
    echo "Note that \$RQ_REDIS_URL is not set from VCAP_SERVICES. If VCAP_SERVICES are being used, Exporter may fail unless redis is local or \$RQ_EXPORTER_HOST is set instead. See https://github.com/mdawar/rq-exporter/blob/master/README.md"
    RQ_REDIS_URL_ARG="--redis-url $RQ_REDIS_URL_ARG"
  fi
fi

if ! [[ -z $PORT ]]; then
  echo "Setting --port exporter arg to \$PORT env var value (which is $PORT)."
  RQ_EXPORTER_PORT_ARG="--port $PORT"
else
  echo "\$PORT env var not set so unless\$RQ_EXPORTER_PORT is otherwise set, the exporter will be served on port 9726."
fi

# Run the exporter
echo "Starting rq_exporter..."
echo "python -m rq_exporter ${RQ_REDIS_URL_ARG:0:22} $RQ_EXPORTER_PORT_ARG"
python -m rq_exporter $RQ_REDIS_URL_ARG $RQ_EXPORTER_PORT_ARG
