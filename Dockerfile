# Use the official PHP 8.2 image as the base image
FROM php:8.2-fpm

ARG USERNAME
ARG USER_UID
# Set working directory
WORKDIR /var/www/html

# Switch to root user to install dependencies
USER root

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    curl \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    iputils-ping

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Configure and install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy existing application directory contents
COPY . /var/www/html

# Copy existing application directory permissions
COPY --chown=${USERNAME}:${USERNAME} . /var/www

# Add user for laravel application
RUN groupadd -g ${USER_UID} ${USERNAME}
RUN useradd -u ${USER_UID} -ms /bin/bash -g ${USERNAME} ${USERNAME}
# Ensure /var/www has the right permissions
RUN chown -R ${USERNAME}:${USERNAME} /var/www
RUN chmod -R 755 /var/www/html


# Switch back to ${USERNAME} user
USER ${USERNAME}

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]