FROM python:3.8.10-buster AS base

WORKDIR /app

RUN apt-get update && \
    apt-get install -y build-essential nodejs npm

RUN npm i -g nodemon

ENV PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=UTF-8

RUN echo 'alias ll="ls -lah"' >> ~/.bashrc

RUN pip install -U \
    pip \
    setuptools \
    wheel \
    watchdog

COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

# Copy those files that are meant to be static
COPY .env.dev .env
COPY setup.py setup.py
COPY nodemon.json nodemon.json
COPY launcher/ launcher/
COPY service/ service/


FROM base AS dev
CMD nodemon .

FROM base AS builder
RUN python setup.py sdist

CMD bash

FROM python:3.8.10-slim AS release

WORKDIR /app

COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

COPY .env .env
COPY launch.bash launch.bash
COPY --from=builder /app/dist /app/dist

CMD bash launch.bash

FROM debian:buster AS tester

WORKDIR /app

RUN echo 'alias ll="ls -lah"' >> ~/.bashrc

RUN apt update && apt upgrade -y
RUN apt install curl -y

RUN curl https://github.com/ovh/venom/releases/download/v1.0.1/venom.linux-amd64 -L -o /usr/local/bin/venom && chmod +x /usr/local/bin/venom

CMD venom run
