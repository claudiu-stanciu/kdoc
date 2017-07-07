# ThinkBig Analytics, a Teradata Company

FROM dmalczyk/kylo:latest
RUN mkdir -p /opt/nifi/oracle && \
    rm -rf /opt/kylo/kylo-services/lib/kylo-commons-jdbc-0.8.1.jar && \
    rm -rf /opt/kylo/kylo-services/conf/log4j-spark.properties
#    rm -rf $SPARK_HOME/conf/spark-defaults.conf

COPY kylo-commons-jdbc-0.8.2-SNAPSHOT.jar /opt/kylo/kylo-services/lib/

COPY ojdbc6.jar /opt/nifi/oracle/
COPY ojdbc6.jar /opt/kylo/kylo-services/plugin/
COPY ojdbc6.jar /opt/kylo/kylo-services/lib/
COPY ojdbc6.jar /usr/local/spark/lib/

COPY log4j-spark.properties /opt/kylo/kylo-services/conf/

COPY hadoop_bootstrap.sh /etc/hadoop_bootstrap.sh

ENV SPARK_CONF_DIR $SPARK_HOME/conf

RUN chown -R nifi:nifi /opt/nifi && \
    chown -R kylo:kylo /opt/kylo/ && \
    echo nifi.service.test-oracle.password=oracle >> /opt/kylo/kylo-services/conf/application.properties && \
    chown -R 500:500 /usr/local/spark/lib/

