FROM nybase/runit:7 AS RUNIT


FROM centos:7

ENV TZ=Asia/Shanghai LANG=C.UTF-8

COPY --from=RUNIT  /usr/local/sbin/ /sbin/ 

RUN yum install -y epel-release ; yum install -y curl wget tzdata net-tools psmisc procps iproute telnet \
      php-fpm php-bcmath php-devel php-mysqlnd php-pgsql php-gd php-cli php-mbstring \
      php-ldap php-soap php-xml php-xmlrpc php-pear \
      php-pecl-redis php-pecl-amqp php-pecl-imagick php-pecl-memcache php-pecl-memcached \
      php-pecl-mongo php-pecl-mongodb php-pecl-libsodium glibc-static ;\
      sed -i -e 's/^listen =.*/listen = 0.0.0.0:9000/g' -e 's/^listen.allowed_clients/;listen.allowed_clients/g' \
      -e 's/^;catch_workers_output/catch_workers_output/g' \
      -e 's/^;request_terminate_timeout =.*/request_terminate_timeout=60/g' \
      -e 's/^;request_slowlog_timeout =.*/request_slowlog_timeout=3/g' \
      -e 's/www-data/nobody/g' -e 's/apache/nobody/g' -e 's/^php_admin_value/;php_admin_value/g' \
      -e 's?^error_log =.*?error_log = /dev/stderr?g' /etc/php-fpm.d/www.conf ;\
      bash -c 'echo -e "expose_php=Off\nupload_max_filesize=80M\npost_max_size=80M\nmemory_limit=256M\nerror_log=syslog\ndate.timezone=Asia/Shanghai" > /etc/php.d/zzzz.ini' ;\
      mkdir -p /etc/service/php ;\
      bash -c 'echo -e "#!/bin/bash\nexec /sbin/php-fpm --nodaemonize --fpm-config /etc/php-fpm.conf" > /etc/service/php/run' ; \
      chmod 755 /etc/service/php/run 

EXPOSE 80/tcp 443/tcp 9000/tcp 7000/tcp

CMD ["runsvdir", "/etc/service"]
#CMD ["/sbin/php-fpm", "-y","/etc/php-fpm.conf","-F"]
 
