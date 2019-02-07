#!/bin/bash

docker network create postgres-barman
docker volume create dbmaster
docker volume create dbstandby
