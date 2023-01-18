ARG PYTHON_VERSION=3.10-slim-bullseye

FROM python:${PYTHON_VERSION}
# enviroments
ARG ENVIRONMENT
ENV DJANGO_ENV=${ENVIRONMENT} \
    # python:
    PYTHONFAULTHANDLER=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONHASHSEED=random \
    # pip:
    PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=100 \
    # poetry:
    POETRY_VERSION=1.3.1 \
    POETRY_VIRTUALENVS_CREATE=false \
    POETRY_CACHE_DIR='/var/cache/pypoetry'

# system dependencies:
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
    libpq-dev \
    build-essential \
    gettext \
    # cleaning cache
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* \
    #
    && pip install --no-cache-dir "poetry==$POETRY_VERSION" && poetry --version
# build local
ARG BUILD_ENVIRONMENT=local
ARG APP_HOME=/src
WORKDIR ${APP_HOME}
COPY pyproject.toml poetry.lock ${APP_HOME}/

# install poetry with caches:
RUN poetry install --with production --with dev --no-interaction --no-ansi \
    && rm -rf ~/.cache/pypoetry/{cache,artifacts} \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    && rm -rf /var/lib/apt/lists/*

COPY ./docker/entrypoint.sh /entrypoint.sh
RUN sed -i 's/\r//' /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY ./docker/scripts/django.sh /run_django.sh
RUN sed -i 's/\r//' /run_django.sh
RUN chmod +x /run_django.sh

COPY ./docker/scripts/celery_worker.sh /run_celery_worker.sh
RUN sed -i 's/\r//' /run_celery_worker.sh
RUN chmod +x /run_celery_worker.sh

COPY ./docker/scripts/celery_beat.sh /run_celery_beat.sh
RUN sed -i 's/\r//' /run_celery_beat.sh
RUN chmod +x /run_celery_beat.sh

COPY ./docker/scripts/celery_flower.sh /run_celery_flower.sh
RUN sed -i 's/\r//' /run_celery_flower.sh
RUN chmod +x /run_celery_flower.sh

COPY . ${APP_HOME}

ENTRYPOINT ["/entrypoint.sh"]
