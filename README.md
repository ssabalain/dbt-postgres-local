# dbt local development with PostgreSQL and PGAdmin

This project sets up a containerized development environment using Docker Compose to work with **PostgreSQL**, **pgAdmin**, and **dbt**. Below is a detailed explanation of each service and instructions for getting started.

---

## 📦 Services

### 1. **Postgres**
- **Image**: `postgres`
- **Purpose**: Provides a PostgreSQL database to serve as the backend for analytics workflows.
- **Ports**: Exposed on `${POSTGRES_PORT}` (defined in `.env`).
- **Features**:
  - Uses a volume (`postgres_data`) for persistent storage of database data.
  - Health check implemented to ensure the service is ready before other dependent services start.

### 2. **pgAdmin**
- **Image**: `dpage/pgadmin4`
- **Purpose**: A web-based interface for managing PostgreSQL databases.
- **Ports**: Exposed on `${PGADMIN_PORT}` (defined in `.env`).
- **Features**:
  - Configurable via environment variables for admin email and password.
  - Includes a custom entrypoint script (`entrypoint.sh`) for additional setup or configuration.
  - Depends on PostgreSQL, ensuring it only starts after the database is healthy.

### 3. **dbt**
- **Build Context**: A custom Dockerfile builds the dbt container.
- **Purpose**: Used for running dbt models, transformations, and other analytics engineering tasks.
- **Environment Variables**:
  - `DBT_PROFILES_DIR` and `DBT_PROJECT_DIR` point to the project directory.
  - `DBT_TARGET` specifies the active dbt target environment.
- **Features**:
  - Includes project files from the current directory as a volume.
  - Runs indefinitely (`sleep infinity`) by default, allowing for interactive use via the terminal.

---

## 🛠️ Setup and Usage

### Prerequisites
- Ensure **Docker** and **Docker Compose** are installed on your system.
- Create a `.env` file in the root directory with the following variables:
  ```env
  POSTGRES_USER=<your_postgres_user>
  POSTGRES_PASSWORD=<your_postgres_password>
  POSTGRES_DB=<your_database_name>
  POSTGRES_PORT=<your_database_port>
  PGADMIN_DEFAULT_EMAIL=<pgadmin_admin_email>
  PGADMIN_DEFAULT_PASSWORD=<pgadmin_admin_password>
  PGADMIN_PORT=<pgadmin_port>

### Commands

#### 1. Build and Start Containers
To build and start all services:
```bash
make build
```

#### 2. Start Containers (Without Rebuilding)
To start the services without rebuilding:
```bash
make up
```

#### 3. Stop and Remove Containers
To stop and remove all running containers:
```bash
make down
```

#### 4. Access the dbt Container
To open an interactive shell inside the dbt container:
```bash
make dbt
```

---

## 📂 File Structure

- **docker-compose.yml:** Defines the services, their dependencies, and configurations.
- **entrypoint.sh:** A custom entrypoint script for pgAdmin setup.
- **.env:** Configuration file to define environment-specific variables.
- **Makefile:** Simplifies common tasks (build, start, stop, etc.)

---

## 🌐 Accessing Services

### pgAdmin

- URL: http://localhost:${PGADMIN_PORT}
- Credentials: Use the email and password defined in your `.env` file.

---

## Notes

- The postgres_data volume ensures that PostgreSQL data persists even if the container is removed.
- The dbt container is designed for interactive use. You can execute dbt