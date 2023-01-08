#!/bin/bash

set -o errexit
set -o nounset

rm -f './celerybeat.pid'

until timeout 5s celery -A config.celery inspect ping; do
    >&2 echo "Celery beat not available"
done
    celery -A config.celery beat -l info -S django
