#================================ General ======================================
name: "${PLAN_NAME:undefined}"

fields:
  plan_name : ${SC_PLAN_NAME:undefined}
  plan_execution_id : ${SC_PLAN_EXECUTION_ID:undefined}
  plan_execution_author : ${SC_PLAN_EXECUTION_AUTHOR:undefined}
  tenant_id : ${SC_TENANT_ID:undefined}

#================================ Inputs ======================================
filebeat.inputs:

- type: log
  enabled: true
  paths:
    - /bzt-configs/tmp/**/kpi.jtl  
  #exclude_lines: ['^DBG']
  #include_lines: ['^ERR', '^WARN']
  #exclude_files: ['.gz$']
  fields:
    sc_plan_execution_author : ${SC_PLAN_EXECUTION_AUTHOR:undefined}
    sc_tenant_id : ${SC_TENANT_ID:undefined}
  #fields_under_root: false
  #ignore_older: 0
  #scan_frequency: 10s
  #harvester_buffer_size: 16384
  #max_bytes: 10485760
  #recursive_glob.enabled: true


#================================ Outputs ======================================
output.logstash:
  enabled: true
  hosts: ["localhost:5044"]
  #worker: 1
  #compression_level: 3
  #escape_html: false
  #ttl: 30s
  #loadbalance: false
  #pipelining: 2
  #slow_start: false
  #backoff.init: 1s
  #backoff.max: 60s
  index: "${SC_TENANT_ID:undefined}_${SC_PLAN_ID:undefined}_${SC_PLAN_EXECUTION_ID:undefined}"
  #max_retries: 3
  #bulk_max_size: 2048
  #timeout: 30s

#setup.ilm.enabled: false 
#ilm.enabled: false