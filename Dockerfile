# elabftw in docker, without sql
FROM ubuntu:14.04
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

# only HTTPS
EXPOSE 443

# install supervisord
RUN /usr/bin/easy_install supervisor

# add files
ADD ./nginx-site.conf /etc/nginx/sites-available/default
ADD ./supervisord.conf /etc/supervisord.conf
ADD ./start.sh /start.sh

# elabftw
RUN git clone --depth 1 -b next https://github.com/NicolasCARPi/elabftw.git /elabftw

# start
CMD ["/start.sh"]

# define mountable directories.
VOLUME ["/etc/nginx/certs", "/var/log/nginx", "/elabftw/uploads"]
