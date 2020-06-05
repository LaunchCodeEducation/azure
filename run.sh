#! /usr/bin/env bash

PORT=8008

docker-compose up -d

echo "docs available at http://localhost:$PORT"