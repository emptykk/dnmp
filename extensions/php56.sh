#!/bin/sh

echo
echo "============================================"
echo "Install extensions from   : php72.sh"
echo "PHP version               : ${PHP_VERSION}"
echo "Extra Extensions          : ${PHP_EXTENSIONS}"
echo "Multicore Compilation     : -j$(nproc)"
echo "Work directory            : ${PWD}"
echo "============================================"
echo


if [ -z "${EXTENSIONS##*,mcrypt,*}" ]; then
    echo "---------- Install mcrypt ----------"
    apk add --no-cache libmcrypt-dev \
    && docker-php-ext-install -j$(nproc) mcrypt
fi


if [ -z "${EXTENSIONS##*,opcache,*}" ]; then
    echo "---------- Install opcache ----------"
    docker-php-ext-install opcache
fi


if [ -z "${EXTENSIONS##*,redis,*}" ]; then
    echo "---------- Install redis ----------"
    mkdir redis \
    && tar -xf redis-4.1.1.tgz -C redis --strip-components=1 \
    && ( cd redis && phpize && ./configure && make -j$(nproc) && make install ) \
    && docker-php-ext-enable redis
fi


if [ -z "${EXTENSIONS##*,memcached,*}" ]; then
	apk add --no-cache libmemcached-dev zlib-dev
    printf "\n" | pecl install memcached-2.2.0
    docker-php-ext-enable memcached
fi


if [ -z "${EXTENSIONS##*,xdebug,*}" ]; then
    echo "---------- Install xdebug ----------"
    mkdir xdebug \
    && tar -xf xdebug-2.5.5.tgz -C xdebug --strip-components=1 \
    && ( cd xdebug && phpize && ./configure && make -j$(nproc) && make install ) \
    && docker-php-ext-enable xdebug
fi


if [ -z "${EXTENSIONS##*,swoole,*}" ]; then
    echo "---------- Install swoole ----------"
    mkdir swoole \
    && tar -xf swoole-2.0.11.tgz -C swoole --strip-components=1 \
    && ( cd swoole && phpize && ./configure && make -j$(nproc) && make install ) \
    && docker-php-ext-enable swoole
fi

if [ -z "${EXTENSIONS##*,pdo_sqlsrv,*}" ]; then
	echo "pdo_sqlsrv requires PHP >= 7.1.0, installed version is ${PHP_VERSION}"
fi
