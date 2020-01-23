FROM nginx

RUN apt-get update \
    && apt-get install -y nginx-extras procps wget ca-certificates less \
    && sed 's%user www-data%user root%' -i /etc/nginx/nginx.conf \
    && rm /etc/nginx/conf.d/*

EXPOSE 5000 80

COPY default.template /default.template
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
