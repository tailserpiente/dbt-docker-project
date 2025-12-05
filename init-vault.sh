#!/bin/bash

# Запрашиваем пароли
read -sp "PostgreSQL password: " PG_PASS
echo ""
read -sp "MSSQL password: " MSSQL_PASS
echo ""

# Ждем Vault
sleep 2

# Добавляем секреты
curl -X POST -H "X-Vault-Token: root-token" \
  -d "{\"data\":{\"password\":\"$PG_PASS\"}}" \
  http://localhost:8200/v1/secret/data/postgres

curl -X POST -H "X-Vault-Token: root-token" \
  -d "{\"data\":{\"password\":\"$MSSQL_PASS\"}}" \
  http://localhost:8200/v1/secret/data/mssql

echo "Secrets added to Vault"

