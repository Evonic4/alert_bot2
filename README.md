# Abot2  
Сontrolled telegram bot for prometheus  
  
Use docker image evonic/abot2:latest  
Configure settings in settings.conf  
  
added receiving alerts from emails, structure:  
start|alertname|group|instance|job|severity|urler|description|unic  
  
---->  
use annotations for grafana:  
    - name: Grafana_Annotation  
      rules:  
      - alert: ga_k8s_health  
        expr: avg(avg_over_time((sum without ()(kube_pod_container_status_ready{namespace=~"kube-system"})/count without ()(kube_pod_container_status_ready{namespace=~"kube-system"}))[3m:3m])) <0.1  
        for: 0m  
        labels:  
          severity: warning  
          groupp: admins3  
          annot_url: 'http://grafana.svc.cluster.local:80/api/annotations'  
          annot_text: 'Accident: k8s no <a href=https://grafana.com/d/9PHBOsO4z/kubernetes>health</a>'  
          annot_tag: accident  
          annot_atoken: glsa_S9RTxMDq654654625hA851oFkM7HSLI_9698c2c3  
        annotations:  
          unicum: '{{$labels.job}}'  
          description: 'Accident (gr_anno)'  
  
use webhook in alert:  
- name: nexp  
  rules:  
  - alert: service_down1  
    expr: up{instance=~"1.2.3.4:9001"} == 0  
    for: 0m  
    labels:  
      severity: disaster  
      groupp: admins1  
      webhook: 'http://5.6.7.8:1234?ferferf=t45t45&fgbgf=t565y6'  
    annotations:  
      unicum: '{{ $labels.job }}'  
      description: 'Service {{ $labels.instance }} ({{ $labels.job }}) down (ne)'  
  