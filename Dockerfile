# Usa una imagen oficial de PHP con extensiones necesarias
FROM php:8.2-fpm

# Instala dependencias del sistema
RUN apt-get update && apt-get install -y \
    zip unzip curl git libpq-dev libonig-dev libzip-dev \
    && docker-php-ext-install pdo pdo_mysql mbstring zip

# Instala Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copia los archivos de Laravel al contenedor
COPY . /var/www
WORKDIR /var/www

# Instala las dependencias de Laravel
RUN composer install --no-dev --optimize-autoloader
RUN php artisan key:generate
RUN php artisan migrate --force
RUN php artisan storage:link

# Expone el puerto 8000
EXPOSE 8000

# Comando para iniciar Laravel
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
