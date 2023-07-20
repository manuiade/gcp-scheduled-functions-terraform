#!/bin/bash

mkdir -p /home/docker
gsutil cp -r gs://$BUCKET/$FILE_PATH/* /home/docker
ls /home/docker
docker build -t primegen /home/docker
docker run --rm --name primegen primegen $PRIME_TARGET 0