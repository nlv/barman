FROM postgres:11

RUN apt-get update; apt-get install -y sudo mc

COPY master/initdb/* ssh/master.prv ssh/master.pub /docker-entrypoint-initdb.d/

RUN ls docker-entrypoint-initdb.d/

ENV BARMAN_SERVER db-barman

RUN useradd -m petitions

RUN mkdir -p /var/lib/postgresql/.ssh && \
    chmod 0700 /var/lib/postgresql/.ssh 

#ADD ssh/master.prv ~postgres/.ssh/id_rsa
#ADD ssh/master.pub ~postgres/.ssh/id_rsa.pub


#RUN chmod -R 600 ~postgres/.ssh/* && \
#    chown -R postgres.postgres ~postgres/.ssh
