#!/bin/bash

# Запрашиваем пароли
read -sp "PostgreSQL password: " PG_PASS
echo ""
read -sp "MSSQL password: " MSSQL_PASS
echo ""

# Ждем Vault
sleep 2

VAULT_TOKEN=$(cat vault_token.txt)

curl -X POST \
  -H "X-Vault-Token: $VAULT_TOKEN" \
  -d '{"type":"kv", "options":{"version":"2"}}' \
  http://localhost:8200/v1/sys/mounts/secret

# Добавляем секреты
curl -X POST -H "X-Vault-Token: $VAULT_TOKEN" \
  -d "{\"data\":{\"password\":\"$PG_PASS\"}}" \
  http://localhost:8200/v1/secret/data/postgres

curl -X POST -H "X-Vault-Token: $VAULT_TOKEN" \
  -d "{\"data\":{\"password\":\"$MSSQL_PASS\"}}" \
  http://localhost:8200/v1/secret/data/mssql

echo "Secrets added to Vault"

