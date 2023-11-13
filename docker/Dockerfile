FROM ubuntu:18.04
MAINTAINER Evonic <gevonic@gmail.com>
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Moscow

USER root
RUN apt update
RUN apt install -y wget git tar curl netcat jq bc perl net-tools tzdata fetchmail procmail
RUN DEBIAN_FRONTEND="noninteractive" apt-get -y --allow-unauthenticated --force-yes -o DPkg::Options::="--force-overwrite" -o DPkg::Options::="--force-confdef" install nullmailer && \
rm -rf /var/lib/apt/lists/* && \
apt clean; \
rm -f /etc/localtime; \
ln -s /usr/share/zoneinfo/Europe/Moscow /etc/localtime

RUN useradd -b /home -m -G adm -p 12345 -s /bin/bash en; \
mkdir -p /home/en/fetchmail/mail/cur; \
mkdir -p /home/en/fetchmail/mail/new; \
mkdir -p /home/en/fetchmail/mail/tmp; \
mkdir -p /home/en/fetchmail/log;

COPY ./procmail.conf /home/en/fetchmail/procmail.conf
COPY ./fetchmail.conf /home/en/fetchmail/fetchmail.conf
RUN chown -R en:en /home/en/fetchmail

WORKDIR /usr/share/
RUN cd /usr/share/; \
git clone https://github.com/Evonic4/alert_bot2.git; \
mv /usr/share/alert_bot2 /usr/share/abot2; \
ls /usr/share/abot2;

WORKDIR /usr/share/abot2;
RUN mkdir -p /usr/share/abot2/sender/1; \
mkdir -p /usr/share/abot2/sender/2; \
chmod 777 -R /usr/share/abot2/;

RUN cd /usr/share/abot2/; \
perl -pi -e "s/\r\n/\n/" /usr/share/abot2/*.sh; \
chmod +rx /usr/share/abot2/*.sh;

VOLUME ["/home/en/fetchmail"]
VOLUME ["/usr/share/abot2"]
WORKDIR /usr/share/abot2
ENTRYPOINT ["bash", "sender.sh"]

EXPOSE 993
EXPOSE 465
