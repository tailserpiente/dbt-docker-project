# DBT Docker Project

Запуск в Docker Compose PostgreSQL pgduckdb+dbt.

## 🚀 Фичи

- **DBT Core** with PostgreSQL adapter
- **Docker** containerization
- **PostgreSQL** database
- **Automated testing** with DBT tests
- **Documentation** generation

## 📁 Project Structure
dbt-project/
├── Dockerfile # DBT image with dependencies
├── docker-compose.yml # Multi-container setup
├── dbt_project/ # DBT project
│ ├── dbt_project.yml # DBT configuration
│ ├── profiles.yml # Database connection
│ └── models/ # DBT models and tests
└── README.md


## 🛠 Quick Start

```bash
# Clone the repository
git clone https://github.com/tailserpiente/dbt-docker-project.git
cd dbt-docker-project

# Start the project
docker compose up -d --build

# Run DBT models
docker compose exec dbt dbt run

# Run tests
docker compose exec dbt dbt test

# View documentation
docker compose exec -d dbt dbt docs serve --port 8080 --host 0.0.0.0

🌐 Access
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
