# STEPS
## Create vms

## GREEN-NODE
192.168.1.70  master-green-node1
192.168.1.71  worker-green-node1
192.168.1.72  worker-green-node2
192.168.1.73  proxy-green-node1

## BLUE-NODE
192.168.1.80  master-blue-node1
192.168.1.81  worker-blue-node1
192.168.1.82  worker-blue-node2
192.168.1.83  proxy-blue-node1


## SonarQube
sonarqube 192.168.1.84

## Nexus
nexus 192.168.1.85

## Jenkins
jenkins 192.168.1.21

## Install dependencies
### On Jenkins
1. jenkins server start up activated
2. docker
3. kubelet
4. trivy
5. pligins: sonarscanner, config-file-provider, maven intergration, pipeline maven intergration, pipeline stage view, docker pipeline, kubernetes, kubernetes CLI
kubernetes client api, kubernetes Credential,

### On nexus
1. docker
2. docker run -d -p 80:8081 sonatype/nexus3

### On sonarcube
1. docker
2. docker run -d -p 80:9000 sonarqube:lts-community