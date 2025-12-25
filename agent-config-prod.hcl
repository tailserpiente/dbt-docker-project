# agent-config-working-fixed.hcl
pid_file = "/tmp/agent.pid"

vault {
   address = "$VAULT_ADDR"
   tls_skip_verify = true
}

auto_auth {
   method {
      type = "token_file"
      config = {
         token_file_path = "/etc/vault/token"
      }
   }
   sink "file" {
      config = {
            path = "tmp/vault-token-via-agent"
      }
   }
}

