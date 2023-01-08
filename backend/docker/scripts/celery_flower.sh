#!/bin/bash

set -o errexit
set -o nounset


until timeout 120s celery -A config.celery inspect ping; do
    >&2 echo "Celery flower not available"
done
    echo 'Starting flower'
    celery \
        -A config.celery \
        -b "${CELERY_BROKER_URL}" \
        flower \
        --basic_auth="${CELERY_FLOWER_USER}:${CELERY_FLOWER_PASSWORD}"
        --loglevel=info
