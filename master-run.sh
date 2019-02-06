docker run --name db-master --volume dbmaster:/var/lib/postgresql/data --network=postgres-barman -e POSTGRES_PASSWORD=1 -e BARMAN_SERVER=db-barman -d nlv/db-master:11
