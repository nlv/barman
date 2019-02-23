# Пример настройки резервного копирования базы данных Postgresql при помощи barman

## Инфраструктура

Пример подготовлен на основе статьи 
How To Back Up, Restore, and Migrate PostgreSQL Databases with Barman on CentOS 7 
(www.digitalocean.com/community/tutorials/how-to-back-up-restore-and-migrate-postgresql-databases-with-barman-on-centos-7)

Пример включает в себя два экземляра базы данных PostgreSql - основная и резервная, 
а так же экземляр barman - утилиты по резервному копированию и восстановлению баз данных Postgresql (www.pgbarman.org).

Все три сервиса развертываеются в docker контейнерах:

* nlv/db-master - основная база данных;
* nlv/db-standby - резервная база данных;
* nlv/db-barman - утилита резервного копирования.

Кроме того, дополнительно создаем два образа для удаленного доступа к файлам баз данных при остановленном сервисе СУБД
(для копирования резервной копии).

* nlv/db-master-ssh;
* nlv/db-standby-ssh.

Пример резервного копирования и восстановления базы данных включает в себя следующие шаги:

1. Подготовка docker контейнеров;
1. Создание основной баз данных и тестовой таблицы;
1. Снятие резервной копии с основной базы;
1. Удаление тестовой таблицы на основной базе;
1. Восстановление резервной копии на основной базе;
1. Установка резервной копии на резервной базе.

Предполагается, что хост-машина управляется linux-системой, на которой установлен docker и команды на ней запускаются с привилегиями root.

# Подготовка docker контейнеров

1. Запускаем скрипт, который создает сеть и тома (хост-машина):

```
# ./init.sh
```

1. Создаем docker-образы баз данных и сервиса резервного копирования (хост-машина):

```
# ./master-build.sh
# ./standby-build.sh
# ./barman-build.sh
```

# Создание основной баз данных и тестовой таблицы

1. Запускаем сервис основной базы (хост-машина):

   ```
   # ./master-run.sh
   ```

1. Заходим в контейнер основной базы (хост-машина):

   ```
   # docker exec -it db-master bash
   ```

1. Создаем тестовую таблицу на основной базе (контейнер основной базы):

   ```
   root@db-master:/# psql -U petitions
   petitions=> create table a (a number);

           List of relations
   Schema | Name | Type  |   Owner   
   -------+------+-------+-----------
   public | a    | table | petitions
   ```

# Снятие резервной копии с основной базы 

1. Заходим в контейнер утилиты barman (хост-машина):

```
# ./barman-run.sh
```

1. Заходим под пользователя barman (контейнер barman):

```
root@db-barman:/# sudo -u barman bash
```

1. Инициализируем резервное копирование с основной базы (контейнер barman):

```
barman@db-barman:/$ barman switch-wal --force --archive master-db-server
```

1. Проверяем, что все в порядке (контейнер barman): 

```
barman@db-barman:/$ barman check master-db-server

Server master-db-server:
   PostgreSQL: OK
   is_superuser: OK
   wal_level: OK
   directories: OK
   retention policy settings: OK
   backup maximum age: OK (no last_backup_maximum_age provided)
   compression settings: OK
   failed backups: OK (there are 0 failed backups)
   minimum redundancy requirements: OK (have 1 backups, expected at least 0)
   ssh: OK (PostgreSQL server)
   not in recovery: OK
   archive_mode: OK
   archive_command: OK
   archiver errors: OK
```

1. Запускаем резервное копирование с основной базы (контейнер barman): 
  
```
barman@db-barman:/$ barman backup master-db-server
```

1. Проверяем и запоминаем ид резервной копии (контейнер barman): 

```
barman@db-barman:/$ barman list-backup master-db-server
master-db-server 20190222T210006 - Fri Feb 22 15:00:10 2019 - Size: 46.4 MiB - WAL Size: 0 B
```

   Ид резервной копии: 20190222T210006.

1. Определяем и время завершения снятия резервной копии (контейнер barman): 

```
barman@db-barman:/$ barman show-backup master-db-server 20190222T210006

 Backup 20190222T210006:
 ...
 End time             : 2019-02-22 15:00:10.689399+00:00
```

   Время завершения снятия резервной копии: 2019-02-22 15:00:10.689399+00:00

# Удаление тестовой таблицы на основной базе

1. Заходим в контейнер основной базы (хост-машина):

```
# docker exec -it db-master bash
```

1. Удаляем тестовую таблцу (контейнер master):

```
root@db-master:/# psql -U petitions
petitions=> drop table a;
petitions=> \t
Did not find any relations.
```

# Восстановление резервной копии на основной базе

1. Останавливаем основную базу и запускаем ssh для доступа службы резервного копирования к основной базе (хост-машина):

```
# docker container stop db-master
# ./master-ssh-run.sh
```

1. В контейнере db-barman запускаем процедуру восстановления основной базы данных
   (указываем ид резервной копии и время завершения снятия этой копии):

```
barman:/# barman recover --target-time "2019-02-22 15:00:10.689399+00:00" --remote-ssh-command "ssh postgres@db-master" master-db-server 20190222T210006 /var/lib/postgresql/data
```

1. В контейнере основной базы данных в настройках postgresql раскоментируем команду archive_command 
   (которая автоматически закоментировается при выполнении процедуры восстановления быза данных сервисом barman):

```
# docker exec -it db-master-ssh bash
root@db-master-ssh:/# vim ~postgres/data/postgresql.conf 
```
     раскоментировать archive_command

1. Запускаем основную базу данных (хост-машина):

```
# docker container stop db-master-ssh
# docker container start db-master
```

1. Проверяем, что таблица восстановилась (контейнер основной базы):

```
# docker exec -it db-master bash
root@db-master:/# psql -U petitions
petitions=> \dt

        List of relations
Schema | Name | Type  |   Owner   
-------+------+-------+-----------
public | a    | table | petitions
```

# Установка резервной копии на резервной базе

1. Запускаем сервис резервной базы данных и создаем эту базу (хост-машина):

```
# ./standby-run.sh
```

1. Останавливаем сервис резервной базы и запускаем сервис ssh для удаленного доступа к файлам этой базы (хост-машина):

```
# docker container stop db-standby
# ./standby-ssh-run.sh
```

1. В контейнере db-barman запускаем процедуру восстановления копии основной базы данных на резервной
   (указываем ид резервной копии и время завершения снятия этой копии):

```
barman@db-barman:/$ barman recover --target-time "2019-02-22 15:00:10.689399+00:00" --remote-ssh-command "ssh postgres@db-standby-ssh" master-db-server 20190222T210006 /var/lib/postgresql/data
```

1. Запускаем сервис резервной базы (хост-машина)

```
# docker container stop db-standby-ssh
# docker container start db-standby
```

1. Проверяем, что в резервной базе появилась тестовая таблица (контейнер резервной базы):

```
# docker exec -it db-standby bash
root@db-standby:/# psql -U petitions
petitions=> \dt

       List of relations
schema | Name | Type  |   Owner   
------+------+-------+-----------
public | a    | table | petitions
```
