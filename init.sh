#!/bin/bash

docker network create postgres-barman
docker volume create dbmaster
docker volume create dbmaster_log
docker volume create dbstandby
docker volume create dbbarman_var
docker volume create dbbarman_log
