#!/bin/bash

echo "host    all     all     $BARMAN_SERVER        trust" >> /var/lib/postgresql/data/pg_hba.conf
