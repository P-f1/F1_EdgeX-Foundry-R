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
echo $Descriptor
echo $DetachedMode
echo $DockerComposeFile

rm -rf ./$DeployType/$InstanceID 
mkdir -p ./$DeployType/$InstanceID/$ServiceName

#cp -R ../artifacts/$Descriptor ./$DeployType/$InstanceID
# https://raw.githubusercontent.com/edgexfoundry/developer-scripts/master/releases/hanoi/compose-files/docker-compose-hanoi-arm64.yml
wget -P $DeployType/$InstanceID "$DockerComposeFile"
mv *.yml docker-compose.yml

cd ./$DeployType/$InstanceID
echo "Deploy from $DeployType/$InstanceID"

Mode=""
if [ "y"==$DetachedMode ]
then
	Mode="-d"
fi

if [[ -v TargetServer ]]; then
	echo "Deploy Remotely !!"
	docker-compose -H "ssh://$Username@$TargetServer" rm -f
	#docker-compose --context $DockerContext up -d
	docker-compose -H "ssh://$Username@$TargetServer" up $Mode --build
else
	echo "Deploy Locally !!"
	docker-compose rm -f
	docker-compose up $Mode --build
fi
