FROM alpine:3.19

ARG PHP_VERSION=81 \
	DB_NAME \
	DB_USER \
	DB_PASS

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
    wget \
    unzip

COPY conf/php-fpm.conf etc/php${PHP_VERSION}/php-fpm.conf

RUN addgroup -S wp_group && adduser -S alvgomez wp_group

WORKDIR /var/www

RUN wget https://wordpress.org/latest.zip && \
    unzip latest.zip && \
    cp -rf wordpress/* . && \
    rm -rf wordpress latest.zip

COPY tools/wp-config-create.sh .

RUN  chmod -R 0777 wp-content 

EXPOSE 9000

CMD [ "sh","wp-config-create.sh" ]
#CMD ["/usr/sbin/php-fpm81", "-F"]
#CMD ["sh", "-c", "while true; do : > /dev/null; sleep 1; done"]