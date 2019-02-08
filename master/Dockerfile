FROM postgres:11

RUN apt-get update; apt-get install -y sudo mc iputils-ping ssh openssh-server

COPY master/initdb/* /docker-entrypoint-initdb.d/

RUN ls docker-entrypoint-initdb.d/

ENV BARMAN_SERVER db-barman

RUN useradd -m petitions

RUN mkdir -p /var/lib/postgresql/.ssh

ADD ssh/master.prv /var/lib/postgresql/.ssh/id_rsa
ADD ssh/master.pub /var/lib/postgresql/.ssh/id_rsa.pub
ADD ssh/barman.pub /tmp

RUN cat /tmp/barman.pub >> ~postgres/.ssh/authorized_keys && \
    chmod 0700 ~postgres/.ssh && \
    chmod -R 600 ~postgres/.ssh/* && \
    chown -R postgres.postgres ~postgres/.ssh


