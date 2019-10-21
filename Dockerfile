FROM centos:7

ENV TZ=Asia/Shanghai LANG=C.UTF-8

RUN yum install -y epel-release ; yum install -y curl wget tzdata net-tools psmisc procps iproute telnet \
      php-fpm php-bcmath php-devel php-mysqlnd php-pgsql php-gd php-cli php-mbstring \
      php-ldap php-soap php-xml php-xmlrpc php-pear \
      php-pecl-redis php-pecl-amqp php-pecl-imagick php-pecl-memcache php-pecl-memcached \
      php-pecl-mongo php-pecl-mongodb php-pecl-libsodium ;\
      sed -i -e 's/^listen =.*/listen = 0.0.0.0:9000/g' -e 's/www-data/nobody/g' -e 's/apache/nobody/g'  /etc/php-fpm.d/www.conf ;\
      bash -c 'echo -e "expose_php=Off\n;upload_max_filesize=80M\npost_max_size=80M\ndate.timezone=Asia/Shanghai" > /etc/php.d/zzzz.ini' 

CMD ["/sbin/php-fpm", "-y","/etc/php-fpm.conf","-F"]
