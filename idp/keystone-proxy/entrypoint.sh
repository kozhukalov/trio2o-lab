#!/bin/sh -e

export KEYSTONE_UWSGI_HOST=${KEYSTONE_UWSGI_HOST:-keystone}
export SERVER_NAME=${SERVER_NAME:-keystone-proxy}

envsubst '$KEYSTONE_UWSGI_HOST $SERVER_NAME' < /default.template > /etc/nginx/sites-available/default

exec nginx -g "daemon off;" -c /etc/nginx/nginx.conf
