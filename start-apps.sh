#!/bin/bash

echo "Getting secrets from Vault Agent..."

VAULT_TOKEN=$(cat vault_token.txt)


export PG_PASSWORD=$(curl -s -H "X-Vault-Token: $VAULT_TOKEN" \
  http://localhost:8200/v1/secret/data/postgres | \
  jq -r '.data.data.password')

export MSSQL_PASSWORD=$(curl -s -H "X-Vault-Token: $VAULT_TOKEN" \
  http://localhost:8200/v1/secret/data/mssql | \
  jq -r '.data.data.password')


# Получаем пароли через Agent API с токеном
#export PG_PASSWORD=$(curl -s -H "X-Vault-Token: root-token" \
#  http://localhost:8100/v1/secret/data/postgres | \
#  grep -o '"password":"[^"]*"' | cut -d'"' -f4)
#
#export MSSQL_PASSWORD=$(curl -s -H "X-Vault-Token: root-token" \
#  http://localhost:8100/v1/secret/data/mssql | \
#  grep -o '"password":"[^"]*"' | cut -d'"' -f4)

echo "PostgreSQL password: ${PG_PASSWORD}"
echo "MSSQL password: ${MSSQL_PASSWORD}"

# Используем полученные пароли или значения по умолчанию
PG_PASSWORD=${PG_PASSWORD}
MSSQL_PASSWORD=${MSSQL_PASSWORD}

# Запускаем приложения с полученными паролями
PG_PASSWORD="$PG_PASSWORD" MSSQL_PASSWORD="$MSSQL_PASSWORD" \
  docker compose -f docker-compose.yml -p dbt-apps up -d

echo "Applications started with secrets from Vault"
