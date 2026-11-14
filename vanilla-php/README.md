# Vanilla PHP Template

A vanilla template for WorldSkills UK competitions: static HTML, CSS and JavaScript and/or plain PHP, served by
PHP 8.3 + Apache. Use it for static pages, PHP pages and APIs alike.

## Features

- **PHP 8.3** with Apache
- **MySQL** database support (PDO and MySQLi)
- **Docker** containerized deployment
- **CI/CD** with GitHub Actions
- **Zero configuration** - just code and deploy

## Quick Start

1. **Choose the entry point** - `index.php` is served before `index.html`: for a static site, delete `index.php`
   and edit `index.html`; for PHP, edit `index.php` (and delete `index.html` if you don't need it)
2. **Create API endpoints** in `api/` directory
3. **Push to deploy** - Automatic build and deployment

## Database Connection

Once deployed, the container receives your module's database as environment variables. To run the project on
your PC, put the same variables in the `.env` file at the root of the project (you fill it in yourself).
Load it with `config.php`, then read the values with `getenv()`:

```php
require_once __DIR__ . '/config.php';

$db_host = getenv('DB_HOST') ?: 'db.worldskills.uk';
$db_name = getenv('DB_DATABASE') ?: 'compXX_module-x';
$db_user = getenv('DB_USERNAME') ?: 'compXX';
$db_pass = getenv('DB_PASSWORD') ?: 'your_password';

$pdo = new PDO(
    "mysql:host=$db_host;dbname=$db_name;charset=utf8mb4",
    $db_user,
    $db_pass,
    [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]
);
```

## Directory Structure

```
vanilla-php/
├── index.php           # PHP entry point (served first: delete it to serve index.html)
├── index.html          # Static entry point
├── config.php          # Loads .env into getenv() (variables already set win)
├── .env                # Your configuration (DB credentials...)
├── api/                # API endpoints
│   ├── hello.php       # Example endpoint
│   └── data.php        # JSON API example
├── Dockerfile          # Docker configuration
└── .github/workflows/  # CI/CD
```

## Creating API Endpoints

Create new PHP files in the `api/` directory:

**api/users.php**
```php
<?php
require_once __DIR__ . '/../config.php';
header('Content-Type: application/json');

// Database connection
$pdo = new PDO(
    "mysql:host=" . getenv('DB_HOST') . ";dbname=" . getenv('DB_DATABASE'),
    getenv('DB_USERNAME'),
    getenv('DB_PASSWORD')
);

// Query
$stmt = $pdo->query("SELECT * FROM users");
$users = $stmt->fetchAll(PDO::FETCH_ASSOC);

// Return JSON
echo json_encode([
    'success' => true,
    'data' => $users
]);
```

## Environment Variables

Once deployed, the container receives them from the competition environment (they win over `.env`). On your PC,
set them in `.env` (Apache never serves it):

- `DB_HOST` - Database host (`competitor_db` once deployed)
- `DB_PORT` - Database port (3306)
- `DB_DATABASE` - Database name (compXX_module-x)
- `DB_USERNAME` - Database user (compXX)
- `DB_PASSWORD` - Database password
- `APP_URL` - URL of the site

## Deployment

Automatic deployment on push to main branch:

```bash
git add .
git commit -m "Update application"
git push
```

Your application will be available at:
`https://wsXX.worldskills.uk/module-x/`

## Local Development

```bash
# Start PHP built-in server
php -S localhost:8000

# Or use Docker
docker build -t vanilla-php-app .
docker run -p 8080:80 vanilla-php-app
```

## Installed PHP Extensions

- PDO
- PDO_MySQL
- MySQLi

## Apache Configuration

- mod_rewrite enabled
- DocumentRoot: `/var/www/html`
- DirectoryIndex: `index.php`, then `index.html`

## Tips

1. Use PDO with prepared statements for security
2. Set appropriate CORS headers for API endpoints
3. Use `http_response_code()` for proper status codes
4. Enable error reporting during development only

## Support

See competition documentation for database credentials and deployment details.
