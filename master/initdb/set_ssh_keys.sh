#!/bin/bash

#mkdir -p /var/lib/postgresql/.ssh 
#chmod 0700 /var/lib/postgresql/.ssh 
#chown postgres.postgres -R /var/lib/postgresql/.ssh

echo S0 >> /tmp/aaa
ls -l /docker-entrypoint-initdb.d >>/tmp/aaa || true
echo S1 >> /tmp/aaa
#cp -v /docker-entrypoint-initdb.d/master.prv ~postgres/.ssh/id_rsa 2>&1 >>/tmp/aaa || true
cp -v /docker-entrypoint-initdb.d/master.pub ~postgres/.ssh/id_rsa.pub 2>&1 >>/tmp/aaa || true
echo S2 >> /tmp/aaa || true
ls -ld ~postgres/.ssh >> /tmp/aaa || true
echo S32 >> /tmp/aaa || true
ls ~postgres/.ssh >> /tmp/aaa|| true
echo S4 >> /tmp/aaa || true

#cp /docker-entrypoint-initdb.d/master.pub ~postgres/.ssh/id_rsa.pub
#rm /docker-entrypoint-initdb.d/master.prv
#rm /docker-entrypoint-initdb.d/master.pub

#chmod -R 600 ~postgres/.ssh 
#chown -R postgres.postgres ~postgres/.ssh
