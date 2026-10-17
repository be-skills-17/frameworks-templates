#!/bin/bash
# CodeIgniter 4 Docker Entrypoint
# Starts Apache immediately, runs migrations in background

echo "=== CodeIgniter 4 Container Starting ==="

# Run migrations in background so Apache starts immediately
(
    sleep 3
    MAX_TRIES=30
    TRIES=0
    # The database passed to the container by the competition environment (read by app/Config/Database.php)
    while [ $TRIES -lt $MAX_TRIES ]; do
        if php -r 'try { new PDO("mysql:host=" . getenv("DB_HOST") . ";port=" . (getenv("DB_PORT") ?: 3306) . ";dbname=" . getenv("DB_DATABASE"), getenv("DB_USERNAME"), getenv("DB_PASSWORD")); echo "OK"; } catch (Exception $e) { exit(1); }' 2>/dev/null | grep -q "OK"; then
            echo "  Database connected"
            cd /var/www/html && php spark migrate --all 2>/dev/null && echo "  Migrations completed" || echo "  [WARN] Migration failed"
            break
        fi
        TRIES=$((TRIES + 1))
        [ $((TRIES % 10)) -eq 0 ] && echo "  Waiting for database... ($TRIES/$MAX_TRIES)"
        sleep 1
    done
) &

echo "Starting Apache..."
exec /usr/sbin/apache2ctl -D FOREGROUND
