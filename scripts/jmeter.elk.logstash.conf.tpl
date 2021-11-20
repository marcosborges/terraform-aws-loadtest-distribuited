input {
    beats {
        port => 5044
    }
}

filter {

    csv {
        separator => ","
        skip_header => true
        skip_empty_rows => true
        columns => [ "timestamp", "elapsed", "label", "response-code", "response-message", "thread-name", "success", "bytes", "grp-threads", "all-threads", "latency", "hostname", "connect" ]
        convert => {
            "elapsed" => "integer"
            "response-code" => "integer"
            "bytes" => "integer"
            "grp-threads" => "integer"
            "all-threads" => "integer"
            "latency" => "integer"
            "connect" => "integer"
            "success" => "boolean"
        }
    }

    date {
        locale => "en"
        match => [ "timestamp", "UNIX_MS" ]
        target => "timestamp"
        #match => [ "timestamp", "ISO8601" ]
        #timezone => "America/Recife"
    }

}

output {
    amazon_es {
        hosts => ["https://${ELASTIC_SEARCH_HOST:search-sobre-carga-fbidabwb7hynmwupzy3heo7nam.us-east-1.es.amazonaws.com}:443"]
        index => "${ELASTIC_SEARCH_INDEX:%{[@metadata][beat]}-%{[@metadata][version]}-%{+YYYY.MM.dd}}"
        user => "${ELASTIC_SEARCH_USER:elastic}"
        password => "${ELASTIC_SEARCH_PASS:changeme}"
        ssl => true
        region => "${AWS_REGION:us-east-1}"
    }
}
