# Daniel Malczyk
# ThinkBig Analytics, a Teradata Company

#basic image with CentOS and latest JDK
FROM airhacks/java

MAINTAINER Daniel Malczyk <dmalczyk@gmail.com>

RUN yum clean all; \
    rpm --rebuilddb; \
    yum install -y curl which tar sudo openssh-server openssh-clients rsync; \
    yum clean all; \
    ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key && \
    ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key && \
    ssh-keygen -q -N "" -t rsa -f /root/.ssh/id_rsa && \
    ssh-keygen -q -N "" -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key && \
    ssh-keygen -q -N "" -t ed25519 -f /etc/ssh/ssh_host_ed25519_key && \
    cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys && \
    # create nifi user and group
    useradd -r -m -s /bin/bash nifi

# install dev tools
ARG NIFI_VERSION=1.3.0
ARG NIFI_INSTALL_HOME=/opt/nifi

RUN mkdir -p ${NIFI_INSTALL_HOME}/current && \
    curl -O http://apache.claz.org/nifi/${NIFI_VERSION}/nifi-${NIFI_VERSION}-bin.tar.gz && \
    tar -xvf nifi-${NIFI_VERSION}-bin.tar.gz -C ${NIFI_INSTALL_HOME}/current && \
    rm -f nifi-${NIFI_VERSION}-bin.tar.gz

# download and install NiFi with Kylo-provided script
COPY install/install-nifi.sh .
COPY scripts/nifi_bootstrap.sh /etc/nifi_bootstrap.sh

RUN chmod u+x ./install-nifi.sh && \
    ./install-nifi.sh ${NIFI_INSTALL_HOME} nifi users && \
    #chown -R nifi:users ${NIFI_INSTALL_HOME}
    chown root.root /etc/nifi_bootstrap.sh && \
    chmod u+x /etc/nifi_bootstrap.sh

ENTRYPOINT ["/etc/nifi_bootstrap.sh"]

# expose NiFi UI
EXPOSE 8079
