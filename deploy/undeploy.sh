#!/bin/bash

Namespace=$1
DeployType=$2
ServiceName=$3
ProjectID=$4
InstanceID=$5

echo $Namespace
echo $DeployType
echo $ServiceName
echo $ProjectID
echo $InstanceID
echo $Username
echo $TargetServer

cd ./$DeployType/$InstanceID/$ServiceName


if [[ -v TargetServer ]]
then
	echo "Undeploy Remotely !!"
	docker-compose -H "ssh://$Username@$TargetServer" down
else
	echo "Undeploy Locally !!"
	docker-compose down
fi
