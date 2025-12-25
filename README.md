# DBT Docker Project
Установка Hashicorp Vault. Пока без настроек аутентификации. 
Запуск в Docker Compose PostgreSQL pgduckdb+dbt.

## 🚀 Фичи
- **HashiCorp Vault** 
- **DBT Core** with PostgreSQL adapter
- **Docker** containerization
- **PostgreSQL** database
- **Automated testing** with DBT tests
- **Documentation** generation

## 📁 Project Structure
dbt-project/
├── Dockerfile                    # DBT образ с зависимостями
├── docker-compose.yml            # Основной compose файл (приложения)
├── docker-compose-vault.yml      # Vault compose файл
├── agent-config.hcl              # Конфигурация Vault Agent
├── init-vault.sh                 # Инициализация Vault с секретами
├── start-apps.sh                 # Запуск приложений с секретами из Vault
├── request-passwords.sh          # Получить пароли PG и MSSQL из Vault в переменные для запуска команд dbt
├── .env                          # Переменные окружения (не в git)
│
├── dbt_project/                  # DBT проект
│   ├── dbt_project.yml           # Конфигурация DBT
│   ├── profiles.yml              # Подключение к БД
│   └── models/                   # Модели и тесты DBT
│
├── templates/                    # Шаблоны для Vault Agent
│   ├── postgres.ctmpl
│   └── mssql.ctmpl
│
└── vault/                        # Данные Vault (том Docker)




## 🛠 Quick Start
```bash
# Clone the repository
git clone https://github.com/tailserpiente/dbt-docker-project.git
cd dbt-docker-project

docker compose up -d --build

#-------------------------------------------------------
# Запуск Vault - DEV без сохранения паролей 
docker compose -f docker-compose-vault.yml -p vault up -d

# Остановка Vault - DEV 
docker compose -f docker-compose-vault.yml -p vault down

# Просмотр логов Vault
docker logs vault
docker logs vault-agent

#-------------------------------------------------------
#-- Запуск Vault - PROD с инициализацией хранилища паролей 
#------------------------------------------------------- 
# Запуск Vault - PROD
docker compose -f docker-compose-vault-prod.yml -p vault up vault -d

###### Разовая инициализация vault - выдача прав на именованные директории в WSL 
mkdir vault_data vault_logs
sudo chown -R 100:1000 vault_data vault_logs
sudo chmod -R 775 vault_data vault_logs

docker exec vault vault operator init
# записать ключи в безопасное место 

docker exec -it vault vault operator unseal
docker exec -it vault vault operator unseal
docker exec -it vault vault operator unseal

docker exec vault vault status

echo "ваш_root_token_здесь" > vault_token.txt
    volumes:
      - ./agent-config.hcl:/etc/vault/config.hcl:ro
      - ./vault_token.txt:/etc/vault/token:ro  # <-- ДОБАВЬТЕ ЭТУ СТРОКУ в yml для agent

docker compose -f docker-compose-vault-prod.yml -p vault up vault-agent -d

#######




# Остановка Vault - DEV 
docker compose -f docker-compose-vault-prod.yml -p vault down

# Просмотр логов Vault
docker logs vault
docker logs vault-agent
#--------------------------------------------------------

## Установка приложений

# задать пароли Postgres, MSSQL, положить в Vault
./init-vault.sh

# Start the project with secrets from Vault
./start-apps.sh

# Получить пароли из Vault при запуске в других сессиях в переменные PG_PASSWORD, MSSQL_PASSWORD
./request-passwords.sh

# Остановка dbt-apps
docker compose -f docker-compose.yml -p dbt-apps down

# Run DBT models
docker compose -p dbt-apps exec dbt dbt run

# Run tests
docker compose -p dbt-apps exec dbt dbt test

# View documentation
docker compose -p dbt-apps exec -d dbt dbt docs serve --port 8080 --host 0.0.0.0

# Проверка подключения к БД
docker exec pgduckdb psql -U postgres -c "SELECT version();"

docker exec mssql-server /opt/mssql-tools18/bin/sqlcmd   -S localhost -U SA -P "$MSSQL_PASSWORD" -C -Q "SELECT @@VERSION"


# Проверка Vault
curl -H "X-Vault-Token: root-token" http://localhost:8100/v1/sys/health


🌐 Access
Vault: http://localhost:8100

PostgreSQL: localhost:5432

DBT Documentation: http://localhost:8080

Database: postgres

Username: postgres

Password: duckdb

📊 Models
example - Simple demonstration model

users - User data model with tests

🧪 Tests
Includes data quality tests for:

Not null constraints

Unique values

Custom data validations
