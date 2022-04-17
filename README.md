# abot2
  
alertmanager telegram mail bot  
  
install from root  
apt-get install mutt && git clone https://github.com/Evonic4/alert_bot2.git && mv ./alert_bot2 /usr/share/abot2/ && chmod +rx /usr/share/abot2/setup.sh && /usr/share/abot2/setup.sh  
  
settings  
/usr/share/abot2/settings.conf  
and  
/usr/share/abot2/list_mail.txt  
and configure mutt /etc/Muttrc.d/smime.rc  
  
start  
cd /usr/share/abot2 && ./trbot.sh  
  
log  
/var/log/trbot/trbot.log  
or STDOUT  
  
alertmanager conf  
receivers:  
  - name: abot2  
    webhook_configs:  
    - send_resolved: True  
      url: http://IP:9087/alert  
  
docker image  
evonic/abot2:latest  
  