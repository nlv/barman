#!/bin/bash

docker run --name db-barman --rm -it --network postgres-barman nlv/db-barman
#docker run --name db-barman --rm --network postgres-barman -d nlv/db-barman bash
