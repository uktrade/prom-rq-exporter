#!/bin/bash
export RQ_REDIS_URL=$(echo $VCAP_SERVICES | jq .redis[].credentials.uri -r)
export RQ_EXPORTER_PORT=$PORT
python -m rq_exporter
