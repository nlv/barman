FROM ubuntu

ENV TZ=Asia/Omsk
ENV LANG ru_RU.utf8

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* && \
    localedef -i ru_RU -c -f UTF-8 -A /usr/share/locale/locale.alias ru_RU.UTF-8

RUN apt-get update && apt-get install -y sudo mc barman iputils-ping ssh openssh-server

ADD ssh/master.pub /tmp
ADD ssh/standby.pub /tmp

RUN mkdir -p ~barman/.ssh && \
    cat /tmp/master.pub >> ~barman/.ssh/authorized_keys && \
    cat /tmp/standby.pub >> ~barman/.ssh/authorized_keys 

ADD ssh/barman.prv /home/barman/.ssh/id_rsa
ADD ssh/barman.pub /home/barman/.ssh/id_rsa.pub

RUN chmod 0700 ~barman/.ssh && \
    chmod -R 600 ~barman/.ssh/* && \
    chown -R barman.barman ~barman/.ssh

EXPOSE 22

CMD service ssh restart && bash

