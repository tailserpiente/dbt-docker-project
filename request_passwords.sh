export PG_PASSWORD=$(curl -s -H "X-Vault-Token: root-token" \
  http://localhost:8100/v1/secret/data/postgres | \
  jq -r '.data.data.password')

export MSSQL_PASSWORD=$(curl -s -H "X-Vault-Token: root-token" \
  http://localhost:8100/v1/secret/data/mssql | \
  jq -r '.data.data.password')


