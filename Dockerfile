FROM ghcr.io/dbt-labs/dbt-core:latest

RUN pip install --upgrade pip

# Устанавливаем необходимые адаптеры и пакеты
RUN pip install dbt-postgres

