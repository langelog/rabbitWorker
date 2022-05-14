#!/usr/bin/env bash

export $(cat .env | xargs)

pip install /app/dist/${SERVICE}-${VERSION}.tar.gz
service
