FROM centos:centos8
LABEL maintainer="Julien Bonnier <j.bonnier@gmail.com>"

ENV PHPFPM_74_BUILD_DEPS \
    php \
    php-common \
    php-fpm \
    php-mysql \
    php-pecl-memcache \
    php-pecl-memcached \
    php-gd \
    php-mbstring \
    php-mcrypt \
    php-xml \
    php-pecl-apc \
    php-cli \
    php-pear \
    php-pdo \
    php-ssh2

ENV PHPFPM_56_BUILD_DEPS \
    php56 \
    php56-php-common \
    php56-php-fpm \
    php56-php-mysql \
    php56-php-pecl-memcache \
    php56-php-pecl-memcached \
    php56-php-gd \
    php56-php-mbstring \
    php56-php-mcrypt \
    php56-php-xml \
    php56-php-pecl-apc \
    php56-php-cli \
    php56-php-pear \
    php56-php-pdo \
    php56-php-ssh2

RUN dnf install --nodocs -y \
        epel-release \
        https://rpms.remirepo.net/enterprise/remi-release-8.rpm \
        # extra packages to help me debug
        vim \
        net-tools \
    && dnf module enable -y php:remi-7.4 \
    && dnf install --nodocs -y \
        httpd \
        openssl \
        mod_ssl \
        supervisor \
        libssh2-devel \
        $PHPFPM_74_BUILD_DEPS \
        $PHPFPM_56_BUILD_DEPS \
    && dnf clean all

COPY config /tmp/

RUN mkdir -p /etc/httpd/sites-available \
    && mkdir -p /etc/httpd/sites-enabled \
    && cp /tmp/vhosts/*.conf /etc/httpd/sites-available/ \
    && openssl req -new -newkey rsa:2048 -days 365 -nodes -x509 \
        -config /tmp/openssl-req.conf \
        -keyout /etc/pki/tls/private/localhost.key \
        -out /etc/pki/tls/certs/localhost.crt \
    && ln -s /etc/httpd/sites-available/php56.conf /etc/httpd/sites-enabled/php56.conf \
    && ln -s /etc/httpd/sites-available/php74.conf /etc/httpd/sites-enabled/php74.conf \
    && mkdir -p /var/www/56 /var/www/74 \
    && cp /tmp/index.php /var/www/56/ \
    && cp /tmp/index.php /var/www/74/ \
    && echo -e '\nServerName localhost' >> /etc/httpd/conf/httpd.conf \
    && echo '# VirtualHost configuration' >> /etc/httpd/conf/httpd.conf \
    && echo 'IncludeOptional sites-available/*.conf' >> /etc/httpd/conf/httpd.conf \
    && mkdir -p /run/php-fpm/ \
    && cp /tmp/supervisord.conf /etc/supervisord.conf \
    && rm -rf /tmp/*

CMD ["/usr/bin/supervisord"]