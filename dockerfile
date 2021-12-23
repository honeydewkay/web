FROM ubuntu:18.04
RUN apt update
RUN apt install apache2 -y
RUN sed -i 's/<\/VirtualHost>//' /etc/apache2/sites-available/000-default.conf
RUN echo 'ProxyRequests Off\n\
ProxyPreserveHost On\n\
<Proxy *>\n\
        Order deny,allow\n\
        Allow from all\n\
</Proxy>\n\
ProxyPass / http://${aws_lb.nlb.dns_name}:8080/\n\
ProxyPassReverse / http://${aws_lb.nlb.dns_name}:8080/\n\
</VirtualHost>' >> /etc/apache2/sites-available/000-default.conf
RUN a2enmod proxy_http
ENTRYPOINT ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]