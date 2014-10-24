# elabftw in docker, without sql
FROM dockerfile/ubuntu
MAINTAINER Nicolas CARPi <nicolas.carpi@curie.fr>

# uncomment for dev build in behind curie proxy
#ADD ./50proxy /etc/apt/apt.conf.d/50proxy
#ENV http_proxy http://www-cache.curie.fr:3128
#ENV https_proxy https://www-cache.curie.fr:3128

# install nginx and php-fpm

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
    nginx \
    openssl \
    php5-fpm \
    php5-mysql \
    php-apc \
    php5-gd \
    php5-curl \
    curl \
    git \
    python-setuptools && \
    rm -rf /var/lib/apt/lists/*

# Nginx config
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
RUN sed -i -e"s/keepalive_timeout\s*65/keepalive_timeout 2/" /etc/nginx/nginx.conf
RUN sed -i -e"s/keepalive_timeout 2/keepalive_timeout 2;\n\tclient_max_body_size 100m/" /etc/nginx/nginx.conf
ADD ./nginx-site.conf /etc/nginx/sites-available/default

# php-fpm config
RUN sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php5/fpm/php.ini
RUN sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 100M/g" /etc/php5/fpm/php.ini
RUN sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 100M/g" /etc/php5/fpm/php.ini
RUN sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php5/fpm/php-fpm.conf
RUN sed -i -e "s/;catch_workers_output\s*=\s*yes/catch_workers_output = yes/g" /etc/php5/fpm/pool.d/www.conf


# Supervisor Config
RUN /usr/bin/easy_install supervisor
ADD ./supervisord.conf /etc/supervisord.conf

# elabftw
RUN git clone --depth 1 -b next https://github.com/NicolasCARPi/elabftw.git /elabftw
# create uploads folder, subfolders and fix permissions
RUN mkdir -p /elabftw/uploads/tmp && mkdir -p /elabftw/uploads/export && chmod -R 777 /elabftw/uploads && chown -R www-data:www-data /elabftw

# create sql db and start supervisord
ADD ./start.sh /start.sh
RUN chmod 755 /*.sh

CMD ["/start.sh"]

# Define mountable directories.
VOLUME ["/etc/nginx/certs", "/var/log/nginx", "/elabftw/uploads"]

# only HTTPS
EXPOSE 443
