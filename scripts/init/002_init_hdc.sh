#!/usr/bin/env bash

set -e

keytab_file=${KRB_KEYTAB_DIR}/${MY_USER}.keytab

/sbin/my_wait_for_file ${keytab_file}
kinit -kt ${keytab_file} ${MY_USER}
