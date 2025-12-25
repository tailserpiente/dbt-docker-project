pid_file = "/tmp/agent.pid"

vault { 
  address = "http://127.0.0.1:8200" 
} 

auto_auth {
   method {
      type = "token_file"
      config = {
         token_file_path = "/etc/vault/token"
      }
   }
}


api_proxy { 
  use_auto_auth_token = true 
} 

listener "tcp" { 
  address = "127.0.0.1:8100" 
  tls_disable = true 
} 

template {
  source      = "/etc/vault/server.key.ctmpl"
  destination = "/etc/vault/server.key"
}

template {
  source      = "/etc/vault/server.crt.ctmpl"
  destination = "/etc/vault/server.crt"
}

