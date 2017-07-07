# ThinkBig Analytics, a Teradata Company

FROM dmalczyk/kylo:latest
RUN mkdir -p /opt/nifi/oracle && \
    rm -rf /opt/kylo/kylo-services/lib/kylo-commons-jdbc-0.8.1.jar && \
    rm -rf /opt/kylo/kylo-services/conf/log4j-spark.properties && \
    rm -rf /usr/local/spark/conf/spark-defaults.conf

COPY kylo-commons-jdbc-0.8.2-SNAPSHOT.jar /opt/kylo/kylo-services/lib/
COPY ojdbc6.jar /opt/nifi/oracle
COPY ojdbc6.jar /opt/kylo/kylo-services/plugin
#COPY ojdbc6.jar /opt/kylo/kylo-services/lib
#COPY ojdbc6.jar /opt/kylo/lib
COPY log4j-spark.properties /opt/kylo/kylo-services/conf/
COPY ojdbc6.jar /usr/local/spark/lib/
#COPY spark-defaults.conf /usr/local/spark/conf/
COPY kylo_bootstrap.sh /etc/kylo_bootstrap.sh

RUN chown -R nifi:nifi /opt/nifi/oracle && \
    chown -R kylo:kylo /opt/kylo/ && \
    echo nifi.service.test-oracle.password=oracle >> /opt/kylo/kylo-services/conf/application.properties
    
