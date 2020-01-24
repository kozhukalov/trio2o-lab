#!/bin/bash

if [[ ! -d /etc/keystone/fernet-keys ]]; then
  mkdir -p /etc/keystone/fernet-keys
fi

export TRANSPORT_URL=${TRANSPORT_URL:-rabbit://keystone:keystone@rabbitmq:5672/openstack/}
export CONNECTION=${CONNECTION:-mysql+pymysql://keystone:keystone@mysql:3306/keystone}
export ENDPOINT_HOST=${ENDPOINT_HOST:-keystone}
export IDP_ENTITY_ID=${IDP_ENTITY_ID:-http://${ENDPOINT_HOST}/identity/OS-FEDERATION/saml2/idp}
export IDP_SSO_ENDPOINT=${IDP_SSO_ENDPOINT:-http://${ENDPOINT_HOST}/identity/OS-FEDERATION/saml2/sso}

envsubst '$TRANSPORT_URL $CONNECTION $IDP_ENTITY_ID $IDP_SSO_ENDPOINT' < /etc/keystone/keystone.conf.template > /etc/keystone/keystone.conf

keystone-manage --config-file /etc/keystone/keystone.conf db_sync
keystone-manage fernet_setup --keystone-user root --keystone-group root
keystone-manage saml_idp_metadata > /etc/keystone/saml2_idp_metadata.xml

keystone-manage bootstrap \
  --bootstrap-password secret \
  --bootstrap-admin-url http://${ENDPOINT_HOST}/identity \
  --bootstrap-public-url http://${ENDPOINT_HOST}/identity \
  --bootstrap-region-id RegionOne

uwsgi /keystone/httpd/keystone-uwsgi-public.ini
