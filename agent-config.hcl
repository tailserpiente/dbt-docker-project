# agent-config.hcl - РАБОЧАЯ версия
vault {
  address = "http://vault:8200"
  token = "root-token"  # <-- Токен прямо здесь
}

listener "tcp" {
  address = "0.0.0.0:8100"
  tls_disable = true
}

# cache можно оставить или убрать - не важно для работы. Нужен auto_auth для него. Комментим пока что. 
#cache {
#  use_auto_auth_token = true
#}

