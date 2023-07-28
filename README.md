# alert_bot2  
telegram prometheus mail bot  
  
------------релизы---------------  
0,62  
fix в выдаче status hc mute  
fixes  
url в label alert  
  - alert: site_is_very_slow  
    expr: sum by (instance,job) (probe_http_duration_seconds) < 100  
    for: 0m  
    labels:  
      severity: warning  
      groupp: admins1  
      url: 'https://www.google.com/{{ humanize $value}}'  
  
  
  
0,61  
-поправлен вывод спецкартинок в зависимости от настроек: (&#10060;)(&#9989) при недоступности прометея  
-команды в конфиге сдвинуть и начинать с 40 строки  
-убран алерт-менеджер  
-работа именно со звуком уведомлений, вынести в конфиг (/mute)  
-автоматические хелсчеки бота в чат, настройка в конфиге и командой (/hс)  
-papi  
-/conf  
  
