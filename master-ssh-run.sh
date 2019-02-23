#!/bin/bash

#  --volume dbmaster_log:/var/log/postgresql \

docker run \
  --name db-master-ssh \
  --volume dbmaster:/var/lib/postgresql/data \
  --network=postgres-barman \
  -e POSTGRES_PASSWORD=1 \
  -e BARMAN_SERVER=db-barman \
  -d nlv/db-master-ssh:11
