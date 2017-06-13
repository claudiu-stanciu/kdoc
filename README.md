# Kylo Docker Layers and Services

The work is based on Keven Wang's Kylo in Docker: https://github.com/keven4ever/kylo_docker

This project aims to dockerize Kylo deployment from source so that the adjacent services are in separate containers and Kylo container is built from NiFi container.
As a goal, Kylo image docker build from sources should be matter of seconds rather than minutes or more...

Each layer should contain only the necessary minimums of settings needed to run with Kylo.
Everything Kylo-related and not needed in deployment-time should be in Kylo layer.

Architecture:
https://docs.google.com/presentation/d/1s-uNcb0QwEIYUqmN_-c-QqVRTYM5_AxluYp9Nxy_iQk/edit#slide=id.g226f3b27bd_0_29

## CURRENT STATUS
The containers are ready but the Kylo image doesn't boot properly.

## TODO
- find all the places where localhost is hard-typed for db, activemq and es
- docker-compose.yml:
    - change/parametrize MYSQL_ROOT_PASSWORD,
    - set resource limits (memory, cpu)
    - externalize mariadb data directory volume
    - externalize kylo and nifi volumes with user data (maybe elasticsearch too?)
- use kylo-ui and kylo-services wars and jars from maven build instead of kylo.rpm or kylo.tar
- make Kylo jars thinner, i.e. change jars and wars dependencies so that external framework libs (Spring) etc are in the image before Kylo jars
- separate Hadoop services to another container
- tune Elasticsearch

## UIs

Kylo - http://localhost:8400
NiFi - http://localhost:8079
Ambari - http://localhost:8080
ActiveMQ Admin - http://localhost:8161


# HOW TO RUN

## Initialization
### Change docker VM settings
Change "vm.max_map_count" kernel variable in the VM running docker daemon: https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html#docker-cli-run-prod-mode.
Increase memory dedicated for Docker (Preferences -> Advanced, currently 10G)
For debugging purposes, Kylo rpm should be now in ./kylo_rpm/kylo.rpm (not included, download from http://bit.ly/2r4P47A)

### Start swarm
```
docker swarm init
```

### Download kylo.rpm
```
mkdir kylo_rpm
curl -o ./kylo_rpm/kylo.rpm -L http://bit.ly/2r4P47A
```

## Build/Start/Stop

### Fetch images
Fetch elasticsearch, activemq, mysql from dockerhub

```
make fetch
```

### Build images
```
make build
```

### Start stack
Builds and fetches before starting the stack.

```
make start
#wait up to 15min and open localhost:8400
```

### Stop stack
```
make stop
```