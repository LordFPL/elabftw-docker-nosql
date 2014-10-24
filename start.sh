#!/bin/bash
# write config file from env var
db_host=$(grep mysql /etc/hosts | awk '{print $1}')
db_name=${DB_NAME}
db_user=${DB_USER}
db_password=${DB_PASSWORD}

cat << EOF > /elabftw/config.php
<?php
define('DB_HOST', '${db_host}');
define('DB_NAME', '${db_name}');
define('DB_USER', '${db_user}');
define('DB_PASSWORD', '${db_password}');
EOF

# start all the services
/usr/local/bin/supervisord -n
