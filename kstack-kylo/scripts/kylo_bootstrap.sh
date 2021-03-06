#!/bin/bash

#in case it's not done in build time
mkdir -p $NIFI_INSTALL_HOME/data/lib/app
cp $NIFI_SETUP_DIR/*.nar $NIFI_INSTALL_HOME/data/lib/
cp $NIFI_SETUP_DIR/kylo-spark-*.jar $NIFI_INSTALL_HOME/data/lib/app/

#/etc/hadoop_bootstrap.sh

#setup Kylo database, service mariadb
echo "Setup Kylo database in MySQL"
#database has to be ready at this point in mariadb service, making a few attempts with pause
attempts=20
while [ $attempts -gt 0 ]
do
    echo "trying to execute db scripts ${attempts} more time(s)."
    echo "testing for kylo database existence"
    dbexists="`mysql -hmariadb -uroot -phadoop -NqsBe \"SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME='kylo'\"`"
    [[ $? -ne 0 ]] && echo "db not ready" && ((attempts--)) && sleep 10 && continue
    if [[ "kylo" == "${dbexists}" ]];
    then
      echo "database already exists. skipping db bootstrap"
      break; #database exists
    else
      /opt/kylo/setup/sql/mysql/setup-mysql.sh mariadb root hadoop
      break;
    fi    
done

## Somehow spark-defaults.conf always overwriten by some process, so we need to append mysql driver when run the container.
## carefully to not have these settings twice in the conf file - spark-submit then fails
#echo "spark.executor.extraClassPath $SPARK_HOME/lib/mysql-connector-java-5.1.41.jar" >> $SPARK_HOME/conf/spark-defaults.conf
#echo "spark.driver.extraClassPath $SPARK_HOME/lib/mysql-connector-java-5.1.41.jar" >> $SPARK_HOME/conf/spark-defaults.conf


# sleep 240 sec to make sure nifi is ready
echo "Sleeping 30s (waiting for NiFi)..."
sleep 30
echo "Starting kylo apps"
#/opt/kylo/start-kylo-apps.sh
/opt/kylo/kylo-ui/bin/run-kylo-ui.sh start
/opt/kylo/kylo-services/bin/run-kylo-services-with-debug.sh start
/opt/kylo/kylo-services/bin/run-kylo-spark-shell.sh start

#cp -r /var/sampledata/* /var/dropzone/


CMD=${1:-"exit 0"}
if [[ "$CMD" == "-d" ]];
then
#	service sshd stop
#	/usr/sbin/sshd -p22 -D -d
        tail -f /dev/null
else
	/bin/bash -c "$*"
fi