#!/bin/bash
# Yii2 Docker Entrypoint
# Starts Apache immediately, runs migrations in background

echo "=== Yii2 Container Starting ==="

# The competition environment passes DB_HOST, DB_PORT, DB_DATABASE, DB_USERNAME and DB_PASSWORD;
# config/web.php reads the DSN from DB_DSN (exported: Apache and its PHP inherit it)
if [ -z "$DB_DSN" ] && [ -n "$DB_HOST" ]; then
    export DB_DSN="mysql:host=$DB_HOST;port=${DB_PORT:-3306};dbname=$DB_DATABASE"
fi

# Run migrations in background so Apache starts immediately
(
    sleep 3
    MAX_TRIES=30
    TRIES=0
    while [ $TRIES -lt $MAX_TRIES ]; do
        if php -r "try { new PDO('$DB_DSN', '$DB_USERNAME', '$DB_PASSWORD'); echo 'OK'; } catch(Exception \$e) { exit(1); }" 2>/dev/null | grep -q "OK"; then
            echo "  Database connected"
            cd /var/www/html && php yii migrate --interactive=0 2>/dev/null && echo "  Migrations completed" || echo "  [WARN] Migration failed"
            break
        fi
        TRIES=$((TRIES + 1))
        [ $((TRIES % 10)) -eq 0 ] && echo "  Waiting for database... ($TRIES/$MAX_TRIES)"
        sleep 1
    done
) &

echo "Starting Apache..."
exec /usr/sbin/apache2ctl -D FOREGROUND
