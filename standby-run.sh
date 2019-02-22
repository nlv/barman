docker run \
  --name db-standby \
  --volume dbstandby:/var/lib/postgresql/data \
  --volume dbstandby_log:/var/log/postgresql \
  --network=postgres-barman \
  -e POSTGRES_PASSWORD=1 \
  -e BARMAN_SERVER=db-barman \
  -d nlv/db-standby:11

