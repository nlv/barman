#!/bin/bash

docker network create postgres-barman
docker volume create dbmain
docker volume create dbstandby
docker volume create dbbarman_var
