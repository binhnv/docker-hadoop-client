#!/usr/bin/env bash

set -e

g_pyhocon_ver="0.3.35"
g_mysql_python_ver="1.2.5"
g_kafka_python_ver="1.2.3"
g_vertica_python_ver="0.6.5"
g_iso8601_version="0.1.11"
g_click_version="6.7"
g_click_log_version="0.1.4"
g_impyla_version="0.13.8"
g_snakebite_version="2.8.2"
g_cheetah_version="2.4.4"
g_redis_version="2.10.3"
g_sqlalchemy_version="1.0.14"
g_setuptools_version="24.0.2"
g_thrift_sasl_version="0.2.1"
g_thrift_version="0.9.3"
g_avro_version="1.8.1"
g_boto3_version="1.4.4"
g_jinja2_version="2.9.5"
g_jaydebeapi_version="1.1.1"

g_spark_home=${SPARK_HOME}
g_sqoop_home=${SQOOP_HOME}
g_spark_bin_url=${SPARK_BIN_URL}
g_sqoop_bin_url=${SQOOP_BIN_URL}
g_spark_conf_dir=${SPARK_CONF_DIR}
g_hive_conf_dir=${HIVE_CONF_DIR}
g_mysql_connector_jar=${MYSQL_CONNECTOR_JAR}
g_flink_home=${FLINK_HOME}
g_flink_bin_url=${FLINK_BIN_URL}

function install_spark {
    echo "Downloading ${g_spark_bin_url}..."
    mkdir -p ${g_spark_home}
    curl -sL ${g_spark_bin_url} | tar -xz -C ${g_spark_home}
    ln -s ${g_hive_conf_dir}/hive-site.xml ${g_spark_conf_dir}/hive-site.xml
    # make spark-submit command available
    ln -s ${g_spark_home}/bin/spark-submit /usr/bin/spark-submit
    ln -s ${g_mysql_connector_jar} ${g_spark_home}/lib/mysql-connector-java.jar
}

function install_sqoop {
    echo "Downloading ${g_sqoop_bin_url}..."
    mkdir -p ${g_sqoop_home}
    curl -sL ${g_sqoop_bin_url} | tar -xz -C ${g_sqoop_home} --strip-component=1
    ln -s ${g_mysql_connector_jar} ${g_sqoop_home}/lib/mysql-connector-java.jar
    # make sqoop command available
    ln -s ${g_sqoop_home}/bin/sqoop /usr/bin/sqoop
}

function install_flink {
    echo "Downloading ${g_flink_bin_url}..."
    mkdir -p ${g_flink_home}
    curl -sL ${g_flink_bin_url} | tar -xz -C ${g_flink_home} --strip-component=1
    # make flink command available
    ln -s ${g_flink_home}/bin/flink /usr/bin/flink
}

function install_os_packages {
    apt-get update
    apt-get install -y --no-install-recommends \
        python-dev \
        libsasl2-dev \
        libmysqlclient-dev \
        rsync \
        build-essential \
        libkrb5-dev \
        cyrus-sasl2-mit-dbg \
        libsasl2-modules-gssapi-mit \
        unzip
}

function install_python_packages {
    pip uninstall setuptools
    pip install setuptools==${g_setuptools_version}
    pip install thrift==${g_thrift_version}
    pip install \
        pyhocon==${g_pyhocon_ver} \
        impyla==${g_impyla_version} \
        snakebite[kerberos]==${g_snakebite_version} \
        cheetah==${g_cheetah_version} \
        redis==${g_redis_version} \
        SQLAlchemy==${g_sqlalchemy_version} \
        MySQL-python==${g_mysql_python_ver} \
        kafka-python==${g_kafka_python_ver} \
        vertica-python==${g_vertica_python_ver} \
        iso8601==${g_iso8601_version} \
        click==${g_click_version} \
        click_log==${g_click_log_version} \
        thrift_sasl==${g_thrift_sasl_version} \
        avro==${g_avro_version} \
        boto3==${g_boto3_version} \
        jinja2==${g_jinja2_version} \
        jaydebeapi==${g_jaydebeapi_version}
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
    install_flink
    cleanup
}

main "$@"
