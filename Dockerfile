FROM python:3.8.10-buster AS dev

WORKDIR /app

RUN apt-get update && \
    apt-get install -y build-essential

ENV PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=UTF-8

RUN echo 'alias ll="ls -lah"' >> ~/.bashrc

RUN pip install -U \
    pip \
    setuptools \
    wheel

COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

COPY .env.dev .env
COPY setup.py setup.py

#CMD run service in development mode
CMD bash

FROM python:3.8.10-slim AS release

WORKDIR /app

COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

COPY .env.release .env
COPY setup.py setup.py
COPY service ./src

#CMD run service in production mode
