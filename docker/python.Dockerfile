##
# App build stage
##
FROM python:3.11-slim-bullseye AS backend_build

ENV PYTHONUNBUFFERED 1
ENV PIP_NO_CACHE_DIR off


RUN apt-get update && apt-get install -y gcc postgresql-client ca-certificates jq  build-essential libpq-dev gnupg \
  && update-ca-certificates \
  && pip install --upgrade pip

RUN apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
  && rm -rf /var/lib/apt/lists/*

# Install MongoDB tools
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 656408E390CFB1F5

RUN echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/debian buster/mongodb-org/4.4 main" | tee /etc/apt/sources.list.d/mongodb-org-4.4.list \
    && apt-get update && apt-get install -y mongodb-org-tools \
    && apt-get install -y mongodb-mongosh \
    && apt-get clean

WORKDIR /app

COPY . /app/

RUN pip install -r ./requirements.txt

CMD ["mongosh"]