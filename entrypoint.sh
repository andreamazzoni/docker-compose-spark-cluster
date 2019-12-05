#!/bin/bash

start_spark_master () {
	cd $SPARK_HOME/conf
	cp spark-env.sh.template spark-env.sh
	echo "export SPARK_MASTER_HOST='master.mysparkcluster.com'" >> spark-env.sh
	#echo "export SPARK_LOCAL_DIRS='/data'" >> spark-env.sh
	echo "master.mysparkcluster.com
slave01.mysparkcluster.com
slave02.mysparkcluster.com" >> slaves
	cd $SPARK_HOME
	./sbin/start-all.sh
}

start_spark_slave () {
	:
}

sudo service ssh start

if [ "$1" = "master" ]; then
	echo "Start Spark master node"
	start_spark_master
fi

if [ "$1" = "slave" ]; then
	echo "Start Spark slave node: $HOSTNAME"
	start_spark_slave
fi

#keep process up
while sleep 60; do
  sleep 60;
done
