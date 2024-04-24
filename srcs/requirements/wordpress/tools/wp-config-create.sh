#!/bin/sh

while ! mariadb -hmariadb -u$DB_USER -p$DB_PASS $DB_NAME &>/dev/null; do
    echo -e "Waiting for the database to be available..."
    sleep 2
done

if [ ! -f "/var/www/wp-config.php" ]; then

cat << EOF > /var/www/wp-config.php
<?php
define( 'DB_NAME', '${DB_NAME}' );
define( 'DB_USER', '${DB_USER}' );
define( 'DB_PASSWORD', '${DB_PASS}' );
define( 'DB_HOST', 'mariadb' );
define( 'DB_CHARSET', 'utf8' );
define( 'DB_COLLATE', '' );
define('FS_METHOD','direct');
\$table_prefix = 'wp_';
define( 'WP_DEBUG', false );
if ( ! defined( 'ABSPATH' ) ) {
define( 'ABSPATH', __DIR__ . '/' );}
define( 'WP_REDIS_HOST', 'redis' );
define( 'WP_REDIS_PORT', 6379 );
define( 'WP_REDIS_TIMEOUT', 1 );
define( 'WP_REDIS_READ_TIMEOUT', 1 );
define( 'WP_REDIS_DATABASE', 0 );
require_once ABSPATH . 'wp-settings.php';
EOF
fi

chmod 775 -R var/www/

curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x /usr/local/bin/wp
ln -s /usr/bin/php81 /usr/bin/php
wp core install --allow-root --url=$DOMAIN_NAME --title=alvgomez --admin_user=$WP_ROOT --admin_password=$WP_ROOT_PASS --admin_email=$WP_ROOT_EMAIL --path=/var/www/
wp user create $WP_USER $WP_EMAIL --user_pass=$WP_PASS --role=author --allow-root --path=/var/www/
wp plugin install redis-cache --activate --allow-root
wp redis enable --allow-root
wp plugin update --all --allow-root
wp rewrite structure '/%postname%/' --hard

/usr/sbin/php-fpm81 -F