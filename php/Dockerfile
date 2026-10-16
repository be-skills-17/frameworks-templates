FROM php:8.3-apache

# Install PHP extensions
RUN docker-php-ext-install pdo pdo_mysql mysqli

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# The web root is the project root: never serve dotfiles (.env holds the DB password)
RUN printf 'RedirectMatch 404 "/\\."\n' > /etc/apache2/conf-available/deny-dotfiles.conf \
    && a2enconf deny-dotfiles

# Copy application files (configuration comes from .env, loaded by config.php)
COPY . /var/www/html/

# Set permissions
RUN chown -R www-data:www-data /var/www/html

# Expose port 80
EXPOSE 80
