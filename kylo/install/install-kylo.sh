#!/bin/bash
DEV=${1}

if [ ${DEV} = "false" ]; then
    curl -o /tmp/kylo.rpm -L http://bit.ly/2r4P47A
else
    git clone https://github.com/Teradata/kylo.git
    export MAVEN_OPTS="-Xms2g -Xmx4g"
    mvn clean install -DskipTests
    mv install/install-rpm/target/rpm/kylo/RPMS/noarch /tmp/kylo.rpm
    rm -rf kylo
fi