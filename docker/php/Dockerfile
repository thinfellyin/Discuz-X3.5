FROM php:8.2-fpm-bookworm

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libwebp-dev \
        libzip-dev \
        libicu-dev \
        unzip; \
    docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp; \
    docker-php-ext-install -j"$(nproc)" \
        mysqli \
        pdo_mysql \
        gd \
        intl \
        zip \
        bcmath \
        opcache; \
    rm -rf /var/lib/apt/lists/*

COPY php.ini /usr/local/etc/php/conf.d/discuz.ini
COPY docker-entrypoint.sh /usr/local/bin/discuz-entrypoint

WORKDIR /var/www/html

RUN chmod +x /usr/local/bin/discuz-entrypoint

ENTRYPOINT ["discuz-entrypoint"]
CMD ["php-fpm"]
