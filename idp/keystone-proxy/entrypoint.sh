#!/bin/sh -e

export KEYSTONE_UWSGI_HOST=${KEYSTONE_UWSGI_HOST:-keystone-uwsgi}
export SERVER_NAME=${SERVER_NAME:-keystone}

envsubst '$KEYSTONE_UWSGI_HOST $SERVER_NAME' < /default.template > /etc/nginx/sites-available/default

exec nginx -g "daemon off;" -c /etc/nginx/nginx.conf
