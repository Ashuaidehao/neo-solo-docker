#!/bin/sh

docker build -t neo-private .
docker rm  --force neo-rc2-private
docker run -dit --name=neo-rc2-private -e INIT_ADDRESS=NhZTTsKwdNQXU9FwadjA8hnU156a8QB5kz  -p 20332-20334:20332-20334 neo-private