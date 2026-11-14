<?php
// Loads the .env file next to this script into getenv() / $_ENV.
// Variables already set win: once deployed, the competition environment passes DB_HOST, DB_PORT, DB_DATABASE,
// DB_USERNAME, DB_PASSWORD and APP_URL to the container; .env is for running the project on your PC.
// Usage: require_once __DIR__ . '/config.php';  (from api/: __DIR__ . '/../config.php')

$envFile = __DIR__ . '/.env';

if (is_readable($envFile)) {
    foreach (file($envFile, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES) as $line) {
        $line = trim($line);
        if ($line === '' || $line[0] === '#' || strpos($line, '=') === false) {
            continue;
        }
        [$key, $value] = array_map('trim', explode('=', $line, 2));
        if (getenv($key) !== false) {
            continue;
        }
        // Strip optional surrounding quotes: KEY="value" or KEY='value'
        if (strlen($value) >= 2 && ($value[0] === '"' || $value[0] === "'") && substr($value, -1) === $value[0]) {
            $value = substr($value, 1, -1);
        }
        putenv("$key=$value");
        $_ENV[$key] = $value;
    }
}
