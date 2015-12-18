FROM iwobble/php5

MAINTAINER Jared Mashburn "jmashburn@iwobble.com"

RUN dnf -y install git-core && dnf clean all

RUN \
    composer self-update && \
    composer create-project \
    composer/satis /opt/satis --stability=dev --keep-vcs

RUN \
    mkdir -p /opt/bin && \
    echo "#!/bin/bash" >> /opt/bin/satis-build && \
    echo "exec /usr/bin/php /opt/satis/bin/satis build /etc/satis.json /var/www/html" \
    >> /opt/bin/satis-build && \
    chmod 777 /opt/bin/satis-build && \
    rm /var/www/html/index.php && \
    echo "No data available" > /var/www/html/index.html

ENV PATH /opt/bin:$PATH

ADD default /etc/nginx/conf.d/default.conf

CMD ["nginx"]
