#!/usr/bin/env bash

set -e

g_pyhocon_ver="0.3.30"
g_mysql_python_ver="1.2.5"
g_kafka_python_ver="1.2.3"
g_vertica_python_ver="0.6.5"
g_iso8601_version="0.1.11"
g_click_version="6.6"
g_click_log_version="0.1.4"
g_impyla_version="0.13.8"
g_snakebite_version="2.8.2"
g_cheetah_version="2.4.4"
g_redis_version="2.10.3"
g_sqlalchemy_version="1.0.14"
g_setuptools_version="24.0.2"

g_spark_home=${SPARK_HOME}
g_sqoop_home=${SQOOP_HOME}
g_spark_bin_url=${SPARK_BIN_URL}
g_sqoop_bin_url=${SQOOP_BIN_URL}
g_spark_conf_dir=${SPARK_CONF_DIR}
g_hive_conf_dir=${HIVE_CONF_DIR}
g_mysql_connector_jar=${MYSQL_CONNECTOR_JAR}

function install_spark {
    echo "Downloading Spark from ${g_spark_bin_url}..."
    mkdir -p ${g_spark_home}
    curl -sL ${g_spark_bin_url} | tar -xz -C ${g_spark_home}
    ln -s ${g_hive_conf_dir}/hive-site.xml ${g_spark_conf_dir}/hive-site.xml
}

function install_sqoop {
    echo "Downloading Sqoop from ${g_sqoop_bin_url}..."
    mkdir -p ${g_sqoop_home}
    curl -sL ${g_sqoop_bin_url} | tar -xz -C ${g_sqoop_home} --strip-component=1
    ln -s ${g_mysql_connector_jar} ${g_spark_home}/lib/mysql-connector-java.jar
}

function install_os_packages {
    apt-get update
    apt-get install -y --no-install-recommends \
        python-dev \
        libsasl2-dev \
        libmysqlclient-dev \
        rsync \
        build-essential
}

function install_python_packages {
    pip uninstall setuptools
    pip install setuptools==${g_setuptools_version}
    pip install \
        pyhocon==${g_pyhocon_ver} \
        impyla==${g_impyla_version} \
        snakebite==${g_snakebite_version} \
        cheetah==${g_cheetah_version} \
        redis==${g_redis_version} \
        SQLAlchemy==${g_sqlalchemy_version} \
        MySQL-python==${g_mysql_python_ver} \
        kafka-python==${g_kafka_python_ver} \
        vertica-python==${g_vertica_python_ver} \
        iso8601==${g_iso8601_version} \
        click==${g_click_version} \
        click_log==${g_click_log_version}
}

function cleanup {
    apt-get remove -y --auto-remove build-essential
    apt-get purge -y build-essential
    apt-get clean
    rm -rf /var/lib/apt/lists/*
}

function main {
    install_os_packages
    install_python_packages
    install_spark
    install_sqoop
    cleanup
}

main "$@"
