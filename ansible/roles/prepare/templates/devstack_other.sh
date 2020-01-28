#!/bin/bash

# this script must be run by stack user

git clone https://opendev.org/openstack/devstack.git -b stable/stein
cd devstack
cat > local.conf <<EOF
[[local|localrc]]
ADMIN_PASSWORD={{admin_password}}
DATABASE_PASSWORD=\$ADMIN_PASSWORD
RABBIT_PASSWORD=\$ADMIN_PASSWORD
SERVICE_PASSWORD=\$ADMIN_PASSWORD
SERVICE_TOKEN=\$ADMIN_PASSWORD

NEUTRON_CREATE_INITIAL_NETWORKS=False

REGION_NAME={{region_name}}

HOST_IP={{ansible_all_ipv4_addresses[0]}}
SERVICE_HOST={{ansible_all_ipv4_addresses[0]}}

KEYSTONE_REGION_NAME={{top_region_name}}
KEYSTONE_SERVICE_HOST={{top_host}}
KEYSTONE_AUTH_HOST={{top_host}}

GLANCE_SERVICE_HOST={{top_host}}
disable_service g-api
disable_service g-reg

disable_service tempest
disable_service horizon
EOF
./stack.sh
