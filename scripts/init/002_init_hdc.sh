#!/usr/bin/env bash

set -e

my_service "wait" ${KRB_SERVICE_NAME}
kinit -kt ${KRB_KEYTAB_DIR}/${MY_USER}.keytab ${MY_USER}
