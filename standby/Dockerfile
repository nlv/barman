FROM postgres:11

RUN apt-get update; apt-get install -y sudo mc iputils-ping ssh openssh-server curl rsync apt-utils vim

COPY main/initdb/* /docker-entrypoint-initdb.d/

ENV BARMAN_SERVER db-barman

RUN useradd -m testdb

RUN mkdir -p /var/lib/postgresql/.ssh

ADD ssh/standby.prv /var/lib/postgresql/.ssh/id_rsa
ADD ssh/standby.pub /var/lib/postgresql/.ssh/id_rsa.pub
ADD ssh/barman.pub /tmp

RUN cat /tmp/barman.pub >> ~postgres/.ssh/authorized_keys && \
    chmod 0700 ~postgres/.ssh && \
    chmod -R 600 ~postgres/.ssh/* && \
    chown -R postgres.postgres ~postgres/.ssh 

RUN echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config

# See: https://groups.google.com/forum/#!topic/pgbarman/SLZETx9itVQ
RUN echo "RemoveIPC=no" >> /etc/systemd/logind.conf 

COPY main/docker-entrypoint_.sh /usr/local/bin
RUN chmod 755 /usr/local/bin/docker-entrypoint_.sh
RUN ln -s /usr/local/bin/docker-entrypoint_.sh /

VOLUME /var/lib/postgresql/data
VOLUME /var/log/postgresql

ENTRYPOINT ["docker-entrypoint_.sh"]
EXPOSE 22 5432

CMD ["postgres"]

