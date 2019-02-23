#!/bin/bash

#  --volume dbmain_log:/var/log/postgresql \

docker run \
  --name db-main-ssh \
  --volume dbmain:/var/lib/postgresql/data \
  --network=postgres-barman \
  -e POSTGRES_PASSWORD=1 \
  -e BARMAN_SERVER=db-barman \
  -d nlv/db-main-ssh:11
