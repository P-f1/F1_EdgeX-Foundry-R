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

# ex. https://raw.githubusercontent.com/edgexfoundry/developer-scripts/master/releases/hanoi/compose-files/docker-compose-hanoi-arm64.yml
wget -P ../artifacts "$DockerComposeFile"

rm -rf ./$DeployType/$InstanceID/$ServiceName
mkdir -p ./$DeployType/$InstanceID/$ServiceName
cp -R ../artifacts/${DockerComposeFile##*/} ./$DeployType/$InstanceID/$ServiceName/docker-compose.yml

cd ./$DeployType/$InstanceID/$ServiceName
echo "Deploy from $DeployType/$InstanceID/$ServiceName"

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
