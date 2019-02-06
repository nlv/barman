FROM ubuntu

ENV TZ=Asia/Omsk
ENV LANG ru_RU.utf8

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
    && localedef -i ru_RU -c -f UTF-8 -A /usr/share/locale/locale.alias ru_RU.UTF-8

RUN apt-get update && apt-get install -y sudo mc barman


