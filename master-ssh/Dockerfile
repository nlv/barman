FROM nlv/db-master:11

RUN mkdir /var/run/sshd
RUN echo 'root:screencast' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

VOLUME /var/lib/postgresql/data
VOLUME /var/log/postgresql

COPY master_stopped/docker-entrypoint_2.sh /usr/local/bin
RUN chmod 755 /usr/local/bin/docker-entrypoint_2.sh
RUN ln -s /usr/local/bin/docker-entrypoint_2.sh /

ENTRYPOINT ["docker-entrypoint_2.sh"]

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]


