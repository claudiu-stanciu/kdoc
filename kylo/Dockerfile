# Daniel Malczyk
# ThinkBig Analytics, a Teradata Company

#starting from NiFi image
FROM dmalczyk/kylo-hadoop:latest

MAINTAINER Daniel Malczyk <dmalczyk@gmail.com>

#download and install Kylo rpm
#RUN curl -o /tmp/kylo.rpm -L http://bit.ly/2r4P47A && rpm -ivh /tmp/kylo.rpm && rm /tmp/kylo.rpm
#COPY kylo_rpm/kylo.rpm /tmp/kylo.rpm
RUN yum clean all; \
    rpm --rebuilddb; \
    yum install -y maven git; \
    yum clean all; \

ARG DEV=false
COPY install/setup/kylo/install-kylo.sh .
RUN chmod u+x ./install-kylo.sh && \
    ./install-kylo.sh ${DEV}

COPY conf/application.properties /opt/kylo/kylo-services/conf/
COPY scripts/kylo_bootstrap.sh /etc/kylo_bootstrap.sh
#sample data to run after kylo start
COPY sample_data/* /var/sampledata/

#add kylo user
RUN useradd -r -m -s /bin/bash kylo && \
    rpm -ivh /tmp/kylo.rpm && rm /tmp/kylo.rpm

# Install Kylo components to NiFi (and possibly start NiFi service)
ENV KYLO_INSTALL_NIFI_SUPPRESS_START "YES" && \
    KYLO_HOME=/opt/kylo

RUN /opt/kylo/setup/nifi/install-kylo-components.sh && \
# "Creating the dropzone folder"
    mkdir -p /var/dropzone && \
    chown nifi:nifi /var/dropzone && \
    chmod 774 /var/dropzone/ && \
    chown -R kylo:kylo /var/sampledata

#setup kylo

ENV PATH $PATH:$KYLO_HOME

# Align the same security.jwt.key as kylo-ui which is generated in kylo post-installation
RUN jwtkey=$(grep 'security.jwt.key' /opt/kylo/kylo-ui/conf/application.properties | awk -F  "=" '/1/ {print $2}') && \
    sed -i "s/security\.jwt\.key=<insert-256-bit-secret-key-here>/security\.jwt\.key=${jwtkey}/" /opt/kylo/kylo-services/conf/application.properties && \
# Make mysql driver available to kylo-spark-shell
    cp /usr/local/apache-hive-2.1.1-bin/lib/mysql-connector-java-5.1.41.jar /opt/nifi/mysql/ && \
# Add spark and hadoop path to PATH env variable for kylo user
    echo "export PATH=$PATH:/usr/local/spark/bin:/usr/local/hadoop/bin" >> /etc/profile

# Add kylo and nifi user to supergroup otherwise kylo-spark-shell service which runs as kylo user will not be able to create database in hive.
RUN groupadd supergroup && \
    usermod -a -G supergroup kylo && \
    usermod -a -G supergroup nifi

# shared volume
RUN mkdir -p /var/share
VOLUME /var/share


RUN chown root.root /etc/kylo_bootstrap.sh
RUN chmod 700 /etc/kylo_bootstrap.sh

# Should always start containers with each ones non-priviledged user
# USER kylo

ENTRYPOINT ["/etc/kylo_bootstrap.sh"]

EXPOSE 8400
