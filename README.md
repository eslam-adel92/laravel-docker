# Laravel/PHP Dockerized Stack

This repository provides a ready-to-use Docker Compose setup for running Laravel or any generic PHP application with minimal configuration. It includes containers for PHP (FPM), Nginx, MySQL, and phpMyAdmin, making local development and testing easy and consistent.

## Features

- **PHP 8.2 (FPM)**: Runs your PHP/Laravel application.
- **Nginx**: Acts as a reverse proxy and serves your application.
- **MySQL 8.0**: Provides a database service.
- **phpMyAdmin**: Web interface for managing your MySQL database.

## Quick Start

1. **Clone or copy these files** into the root of your PHP/Laravel project.

2. **Configure environment variables**:
   - Copy the example environment file:
     ```sh
     cp docker-files/env.example docker-files/.env
     ```
   - Edit `docker-files/.env` and fill in all required parameters (e.g., `app_name`, `webapp_port`, `DB_ROOT_PASSWORD`, etc.).

3. **Build and start the containers**:
   ```sh
   docker compose --env-file docker-files/.env up --build -d
   ```
4. **Access your application**:
   - Visit `http://localhost:<webapp_port>` in your browser.
   - Access PhpMyAdmin at `http://localhost:<phpmyadmin_port>`.

## Directory Structure

- docker-compose.yaml: Main Docker Compose configuration.
- Dockerfile: Builds the PHP application image.
- docker-files
  - env.example: Template for environment variables.
  - default.conf: Nginx configuration.
  - local.ini: PHP custom settings (e.g., upload limits).
  - my.cnf: MySQL custom configuration.
  - supervisord.conf: Supervisor config for running Laravel queue and schedule jobs.

## Customization

- **Nginx**: Modify default.conf to change server or routing settings.
- **PHP**: Adjust local.ini for PHP-specific settings.
- **MySQL**: Edit my.cnf for database configuration.
- **Supervisor**: Update supervisord.conf to manage background jobs.

## Important Note About USER_UID

Before running the stack, ensure that the `USER_UID` variable in your `.env` file matches the user ID of the host user who will run the containers. This helps prevent permission issues when accessing files created by the containers on your host system.

For example, if you are running on an Ubuntu machine with the user `ubuntu` whose user ID is `1000`, set:

```
USER_UID=1000
```

in your `.env` file.

You can find your user ID by running:

```sh
id -u
```

## Running Commands from Outside the Container

You can interact with your containers directly from your host machine using Docker Compose commands. Here are some useful examples:

- **List all running containers:**
  ```sh
  docker compose --env-file docker-files/.env ps
  ```

- **Running Laravel Migrations:**

To run Laravel migrations inside the Docker container, use the following command from your project root:

```sh
docker compose --env-file docker-files/.env exec -it app bash -c "php artisan migrate"
```

## Notes

- Make sure the ports you set in `.env` are available on your host machine.
- Volumes are used for persistent database and phpMyAdmin data.
- The stack is suitable for local development and testing.

---

Feel free to adapt this setup for your specific PHP or Laravel project needs!