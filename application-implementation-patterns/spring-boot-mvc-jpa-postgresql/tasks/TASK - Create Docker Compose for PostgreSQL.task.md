# TASK - Create_Docker_Compose_for_PostgreSQL

## Output



- File: project_root/docker-compose.yml

```yaml
version: "3.9"

services:
  postgres:
    image: postgres:16
    container_name: postgres-shopping
    restart: unless-stopped
    ports:
      - "${DATABASE_PORT}:5432"
    environment:
      POSTGRES_USER: "${DATABASE_USERNAME}"
      POSTGRES_PASSWORD: "${DATABASE_PASSWORD}"
      POSTGRES_DB: "${DATABASE_NAME}"
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${DATABASE_USERNAME} -d ${DATABASE_NAME}"]
      interval: 5s
      timeout: 3s
      retries: 20
    volumes:
      - pgdata:/var/lib/postgresql/data
      - ./db/init:/docker-entrypoint-initdb.d:ro
    env_file:
      - .env

volumes:
  pgdata:

```


- Add docker-compose section to readme.md. 