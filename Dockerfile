FROM php:7.4-fpm
RUN apt-get clean
RUN apt-get update
RUN apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libzip-dev \
        zip \
        libpq-dev
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install -j$(nproc) gd gettext zip pdo pdo_pgsql
RUN printf '[PHP]\ndate.timezone = "Europe/Amsterdam"\n' > /usr/local/etc/php/conf.d/tzone.ini
COPY spotweb.ini /usr/local/etc/php-fpm.d/
WORKDIR /spotweb
