#!/bin/bash

export OS_AUTH_TYPE=password
export OS_AUTH_URL=${OS_AUTH_URL:-http://keystone/identity}
export OS_IDENTITY_API_VERSION=3
export OS_PROJECT_NAME=${OS_PROJECT_NAME:-admin}
export OS_PROJECT_DOMAIN_ID=${OS_PROJECT_DOMAIN_ID:-default}
export OS_USER_DOMAIN_ID=${OS_USER_DOMAIN_ID:-default}
export OS_USERNAME=${OS_USERNAME:-admin}
export OS_PASSWORD=${OS_PASSWORD:-secret}

exec /bin/bash
