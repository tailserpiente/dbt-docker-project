pid_file = "/vault/agent/pidfile"

auto_auth {
  method "approle" {
    mount_path = "auth/approle"
    config = {
      role_id_file_path = "/vault/agent/role_id"
      secret_id_file_path = "/vault/agent/secret_id"
      remove_secret_id_file_after_reading = false
      secret_id_response_wrapping_path = "auth/approle/role/agent/secret-id"
    }
  }

  sink "file" {
    config = {
      path = "/vault/agent/token"
    }
  }
}

vault {
  address = "http://vault:8200"
  tls_skip_verify = true
}

template_config {
  static_secret_render_interval = "5m"
  exit_on_retry_failure = true
}

# Шаблон для PostgreSQL пароля
template {
  source      = "/vault/agent/templates/postgres.env.tmpl"
  destination = "/secrets/postgres.env"
  perms       = 0640
  command     = "echo 'PostgreSQL секреты обновлены'"
}

# Шаблон для MSSQL пароля
template {
  source      = "/vault/agent/templates/mssql.env.tmpl"
  destination = "/secrets/mssql.env"
  perms       = 0640
  command     = "echo 'MSSQL секреты обновлены'"
}

# Шаблон для DBT профиля
template {
  source      = "/vault/agent/templates/dbt_profiles.yml.tmpl"
  destination = "/dbt_project/profiles.yml"
  perms       = 0644
  command     = "echo 'DBT профиль обновлен'"
}

# Шаблон для DuckDB конфигурации
template {
  source      = "/vault/agent/templates/duckdb_config.json.tmpl"
  destination = "/lakehouse/connections.json"
  perms       = 0644
  command     = "echo 'DuckDB конфиг обновлен'"
}

# Шаблон для общего .env файла
template {
  source      = "/vault/agent/templates/global.env.tmpl"
  destination = "/secrets/.env"
  perms       = 0640
  command     = "echo 'Глобальные секреты обновлены'"
}
