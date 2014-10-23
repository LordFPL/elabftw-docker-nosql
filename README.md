# elabftw docker nosql

Build an elabftw container with nginx + php-fpm but without sql.
You need to link this container to an SQL container.

It expects the certs to be server.key and server.crt.

Command to start it :
~~~
docker run -p 443:443 -v /tmp/config.php:/elabftw/config.php -v /tmp/elab-uploads:/elabftw/uploads -v /tmp/nginx-certs:/etc/nginx/certs -d --link mysql:mysql nicolascarpi/elabftw-nosql
~~~

For debugging you can add a :
~~~
-v /tmp/nginx-logs:/var/log/nginx
~~~

This is a work in progress, don't use it !
