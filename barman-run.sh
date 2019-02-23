#!/bin/bash

#  --volume=dbbarman_log:/var/log/barman \

docker run \
  --name db-barman \
  --rm -it \
  --network postgres-barman \
  --volume=dbbarman_var:/var/lib/barman \
  nlv/db-barman
