FROM alpine:3.19

ARG PHP_VERSION=81 \
	DB_NAME \
	DB_USER \
	DB_PASS \
	WP_USER \
	WP_PASS \
	WP_EMAIL \
	DOMAIN_NAME

RUN apk update && apk upgrade && apk add --no-cache \
    php${PHP_VERSION} \
    php${PHP_VERSION}-fpm \
    php${PHP_VERSION}-mysqli \
    php${PHP_VERSION}-json \
    php${PHP_VERSION}-curl \
    php${PHP_VERSION}-dom \
    php${PHP_VERSION}-exif \
    php${PHP_VERSION}-fileinfo \
    php${PHP_VERSION}-mbstring \
    php${PHP_VERSION}-openssl \
    php${PHP_VERSION}-xml \
    php${PHP_VERSION}-zip \
	php${PHP_VERSION}-phar \
	php${PHP_VERSION}-iconv \
	wget \
    curl \
    unzip

COPY conf/php-fpm.conf etc/php${PHP_VERSION}/php-fpm.conf

RUN addgroup -S wp_group && adduser -S alvgomez wp_group

WORKDIR /var/www

RUN wget https://wordpress.org/latest.zip && \
    unzip latest.zip && \
    cp -rf wordpress/* . && \
    rm -rf wordpress latest.zip

COPY tools/wp-config-create.sh .

RUN  chmod -R 0777 wp-content && chmod +x wp-config-create.sh

EXPOSE 9000

CMD [ "./wp-config-create.sh" ]