FROM jenkins/jnlp-slave:alpine as jnlp

FROM node:alpine

RUN apk update && apk upgrade --no-cache

RUN apk --no-cache -U add openjdk8-jre wget tar gzip git php7 php7-phar php7-fpm php7-openssl php7-sqlite3 php7-pear php7-pdo_mysql php7-xsl php7-imagick php7-mysqlnd php7-redis php7-mbstring php7-fileinfo php7-xmlrpc php7-pdo_sqlite php7-xmlreader php7-exif php7-session php7-gd php7-json php7-xml php7-curl php7-pgsql php7-zip php7-mcrypt php7-bcmath php7-amqp php7-sockets php7-memcached php7-zlib php7-pdo php7-mysqli php7-simplexml php7-xmlwriter php7-tokenizer php7-ctype

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php --install-dir=/usr/local/bin --filename=composer
RUN php -r "unlink('composer-setup.php');"

COPY --from=jnlp /usr/local/bin/jenkins-slave /usr/local/bin/jenkins-agent
COPY --from=jnlp /usr/share/jenkins/slave.jar /usr/share/jenkins/slave.jar

ENTRYPOINT ["/usr/local/bin/jenkins-agent"]
