FROM ubuntu:18.04
MAINTAINER Evonic <gevonic@gmail.com>
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Moscow

USER root
RUN apt update
RUN apt install -y wget git tar curl netcat jq bc perl tzdata mutt && \
rm -rf /var/lib/apt/lists/* && \
apt clean; \
rm -f /etc/localtime; \
ln -s /usr/share/zoneinfo/Europe/Moscow /etc/localtime

WORKDIR /usr/share/
RUN cd /usr/share/; \
git clone https://github.com/Evonic4/alert_bot2.git; \
mv /usr/share/alert_bot2 /usr/share/abot2; \
ls /usr/share/abot2;

WORKDIR /usr/share/abot2;
RUN mkdir -p /usr/share/abot2/sender/1; \
mkdir -p /usr/share/abot2/sender/2; \
mkdir -p /var/log/trbot/; \
chmod 777 -R /usr/share/abot2/; \
echo "" > /var/log/trbot/trbot.log;

RUN cd /usr/share/abot2/; \
perl -pi -e "s/\r\n/\n/" /usr/share/abot2/*.sh; \
chmod +rx /usr/share/abot2/*.sh;

VOLUME ["/etc/Muttrc.d"]
VOLUME ["/usr/share/abot2"]
WORKDIR /usr/share/abot2
ENTRYPOINT ["bash", "sender.sh"]
