# Utilizar una imagen base de PHP con Apache
FROM php:7.4-apache

# Instalar dependencias
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    git \
    curl \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zip \
    unzip \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql

# Instalar Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Establecer el directorio de trabajo
WORKDIR /var/www/html

# Copiar archivos de la aplicación
COPY . .

# Instalar dependencias de PHP usando Composer
RUN composer install --no-dev --no-interaction --no-progress --optimize-autoloader

# Limpiar
RUN apt-get clean && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apt/*

# Exponer el puerto
EXPOSE 80

# Comando para iniciar el servidor
CMD ["apache2-foreground"]
