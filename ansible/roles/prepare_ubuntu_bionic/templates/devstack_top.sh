#!/bin/bash

# this script must be run by stack user only on top pod

git clone https://opendev.org/openstack/devstack.git -b stable/stein
cd devstack
cat > local.conf <<EOF
[[local|localrc]]
ADMIN_PASSWORD={{admin_password}}
DATABASE_PASSWORD=\$ADMIN_PASSWORD
RABBIT_PASSWORD=\$ADMIN_PASSWORD
SERVICE_PASSWORD=\$ADMIN_PASSWORD
SERVICE_TOKEN=\$ADMIN_PASSWORD

TRIO2O_START_SERVICES=True
enable_plugin trio2o https://opendev.org/x/trio2o

disable_service horizon
disable_service tempest

EOF
./stack.sh
