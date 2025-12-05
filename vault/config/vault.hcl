storage "raft" {
  path    = "/vault/data"
  node_id = "node1"
  
  retry_join {
    leader_api_addr = "http://vault:8200"
  }
}

listener "tcp" {
  address            = "0.0.0.0:8200"
  cluster_address    = "0.0.0.0:8201"
  tls_disable        = true
  telemetry {
    unauthenticated_metrics_access = true
  }
}

telemetry {
  prometheus_retention_time = "30s"
  disable_hostname = true
}

api_addr     = "http://vault:8200"
cluster_addr = "https://vault:8201"
ui           = true

# Настройки для разработки (можно убрать в продакшене)
disable_mlock = true
default_lease_ttl = "768h"
max_lease_ttl = "8760h"

# Разрешаем CORS для UI
raw_storage_endpoint = true
