# Use an official PHP image with necessary extensions
FROM php:8.2-fpm

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    unzip \
    vim \
    mariadb-client \
    nginx \
    supervisor \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    libzip-dev \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip

# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set up working directory for WordPress (Bedrock) and Laravel
WORKDIR /var/www

# Install Laravel and Bedrock
# You should already have both repositories in your project structure
COPY ./laravel /var/www/laravel
COPY ./bedrock /var/www/bedrock

# Install dependencies for Bedrock (WordPress) and Laravel
RUN cd /var/www/laravel && composer install
RUN cd /var/www/bedrock && composer install

# Set the ownership and permissions
RUN chown -R www-data:www-data /var/www
RUN chmod -R 755 /var/www

# Nginx configuration
COPY ./nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./nginx/sites-enabled/ /etc/nginx/sites-enabled/

# Supervisor configuration for managing Nginx and PHP-FPM
COPY ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Expose ports
EXPOSE 80

# Start Supervisor to run PHP-FPM and Nginx
CMD ["/usr/bin/supervisord"]
