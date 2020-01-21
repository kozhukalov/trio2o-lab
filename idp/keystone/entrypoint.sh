#!/bin/bash

if [[ ! -d /etc/keystone/fernet-keys ]]; then
  mkdir -p /etc/keystone/fernet-keys
fi

export TRANSPORT_URL=${TRANSPORT_URL:-rabbit://keystone:keystone@rabbitmq:5672/openstack/}
export CONNECTION=${CONNECTION:-mysql+pymysql://keystone:keystone@mysql:3306/keystone}
export ENDPOINT_HOST=${ENDPOINT_HOST:-keystone}

envsubst '$TRANSPORT_URL $CONNECTION' < /etc/keystone/keystone.conf.template > /etc/keystone/keystone.conf

keystone-manage --config-file /etc/keystone/keystone.conf db_sync
keystone-manage fernet_setup --keystone-user root --keystone-group root

keystone-manage bootstrap \
  --bootstrap-password secret \
  --bootstrap-admin-url http://${ENDPOINT_HOST}:5000/v3/ \
  --bootstrap-internal-url http://${ENDPOINT_HOST}:5000/v3/ \
  --bootstrap-public-url http://${ENDPOINT_HOST}:5000/v3/ \
  --bootstrap-region-id RegionOne

uwsgi /keystone/httpd/keystone-uwsgi-public.ini
