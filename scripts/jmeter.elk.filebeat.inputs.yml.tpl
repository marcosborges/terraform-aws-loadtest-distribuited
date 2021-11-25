#================================ General ======================================
name: "$${PLAN_NAME:undefined}"
fields:
  plan_name : $${PLAN_NAME:undefined}

#================================ Inputs ======================================
filebeat.inputs:

- type: log
  enabled: true
  paths:
    - /loadtest/tmp/**/kpi.jtl
  #exclude_lines: ['^DBG']
  #include_lines: ['^ERR', '^WARN']
  #exclude_files: ['.gz$']
  fields:
    plan_name : $${PLAN_NAME:undefined}
  #fields_under_root: false
  #ignore_older: 0
  #scan_frequency: 10s
  #harvester_buffer_size: 16384
  #max_bytes: 10485760
  #recursive_glob.enabled: true

#================================ Outputs ======================================
output.logstash:
  enabled: true
  hosts: ["$${LEADER_IP}:5044"]
  #worker: 1
  #compression_level: 3
  #escape_html: false
  #ttl: 30s
  #loadbalance: false
  #pipelining: 2
  #slow_start: false
  #backoff.init: 1s
  #backoff.max: 60s
  index: "$${ELASTIC_INDEX}"
  #max_retries: 3
  #bulk_max_size: 2048
  #timeout: 30s

#setup.ilm.enabled: false 
#ilm.enabled: false