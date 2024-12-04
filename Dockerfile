FROM python:3.9-slim

RUN apt-get update && \
    apt-get install -y git && \
    pip install dbt-postgres

WORKDIR /usr/app/dbt

CMD ["sleep", "infinity"]