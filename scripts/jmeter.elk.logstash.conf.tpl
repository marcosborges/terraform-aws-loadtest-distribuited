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
        columns => [ 
            "timestamp", 
            "elapsed", 
            "label", 
            "response-code", 
            "response-message", 
            "thread-name", 
            "success", 
            "bytes", 
            "grp-threads", 
            "all-threads", 
            "latency", 
            "hostname", 
            "connect" 
        ]
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
    }

}

output {
    amazon_es {
        hosts => ["$${ELASTIC_HOSTNAME}"]
        index => "$${ELASTIC_INDEX}"
        user => "$${ELASTIC_USERNAME:elastic}"
        password => "$${ELASTIC_PASSWORD:changeme}"
        ssl => true
        region => "$${AWS_REGION:us-east-1}"
    }
}
