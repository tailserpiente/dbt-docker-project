
VAULT_TOKEN=$(cat vault_token.txt)

export PG_PASSWORD=$(curl -s -H "X-Vault-Token: $VAULT_TOKEN" \
  http://localhost:8200/v1/secret/data/postgres | \
  jq -r '.data.data.password')

export MSSQL_PASSWORD=$(curl -s -H "X-Vault-Token: $VAULT_TOKEN" \
  http://localhost:8200/v1/secret/data/mssql | \
  jq -r '.data.data.password')


echo $PG_PASSWORD
echo $MSSQL_PASSWORD
