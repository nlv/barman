#!/bin/bash

cp /docker-entrypoint-initdb.d/postgresql.conf ~postgres/data
cp /docker-entrypoint-initdb.d/pg_hba.conf ~postgres/data
