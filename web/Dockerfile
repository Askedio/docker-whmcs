FROM php:8.2-apache

# --- Install required system libs and PHP extensions WHMCS expects ---
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        wget \
        curl \
        libzip-dev \
        libpng-dev \
        libjpeg-dev \
        libonig-dev \
        libicu-dev \
        libxml2-dev \
        libcurl4-openssl-dev \
        unzip \
        git \
    ; \
    docker-php-ext-configure gd --with-jpeg; \
    docker-php-ext-install -j"$(nproc)" pdo_mysql gd mbstring intl xml curl zip; \
    a2enmod rewrite; \
    # allow .htaccess (WHMCS needs clean URLs)
    sed -ri 's/AllowOverride\s+None/AllowOverride All/i' /etc/apache2/apache2.conf; \
    rm -rf /var/lib/apt/lists/*

# --- Install ionCube Loader for THIS php build ---
# We:
#  - detect PHP major.minor (8.2)
#  - detect extension_dir (/usr/local/lib/php/extensions/no-debug-non-zts-XXXXXXXX)
#  - download ionCube bundle
#  - copy the correct loader .so
#  - write a clean 00-ioncube.ini that Apache+CLI will both load
RUN set -eux; \
    PHP_SHORT="$(php -r 'echo PHP_MAJOR_VERSION . "." . PHP_MINOR_VERSION;')"; \
    EXT_DIR="$(php -r 'echo ini_get("extension_dir");')"; \
    cd /tmp; \
    curl -fsSL -o ioncube.tar.gz https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz; \
    tar -xzf ioncube.tar.gz; \
    cp "ioncube/ioncube_loader_lin_${PHP_SHORT}.so" "${EXT_DIR}/"; \
    echo "zend_extension=${EXT_DIR}/ioncube_loader_lin_${PHP_SHORT}.so" > /usr/local/etc/php/conf.d/00-ioncube.ini; \
    rm -rf /tmp/ioncube /tmp/ioncube.tar.gz

# --- Dev php.ini overrides (errors on, sane limits, etc.) ---
COPY php.ini /usr/local/etc/php/conf.d/99-custom.ini

WORKDIR /var/www/html
