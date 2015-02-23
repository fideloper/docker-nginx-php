FROM phusion/baseimage:0.9.16

ENV HOME /root

RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

CMD ["/sbin/my_init"]

# Nginx-PHP Installation
RUN add-apt-repository -y ppa:nginx/stable && add-apt-repository -y ppa:ondrej/php5 && apt-get update && \
    apt-get install -y --force-yes python-software-properties && \
    php5-cli php5-fpm php5-mysql php5-pgsql php5-sqlite php5-curl php5-gd php5-mcrypt && \
    php5-intl php5-imap php5-tidy nginx && apt-get clean

RUN sed -i "s/;date.timezone =.*/date.timezone = UTC/" /etc/php5/fpm/php.ini && \
    sed -i "s/;date.timezone =.*/date.timezone = UTC/" /etc/php5/cli/php.ini && \
    echo "daemon off;" >> /etc/nginx/nginx.conf && \
    sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php5/fpm/php-fpm.conf && \
    sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php5/fpm/php.ini

RUN mkdir -p        /var/www /etc/service/nginx /etc/service/phpfpm
ADD build/default   /etc/nginx/sites-available/default
ADD build/nginx.sh  /etc/service/nginx/run
ADD build/phpfpm.sh /etc/service/phpfpm/run
RUN chmod +x        /etc/service/nginx/run /etc/service/phpfpm/run

EXPOSE 80
