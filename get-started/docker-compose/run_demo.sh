#!/bin/bash

type -p lacadmin &>/dev/null  || { echo "***** lacadmin command not found.  Install from https://github.com/EspressoLogicCafe/CALiveAPICreatorAdminCLI *****"; exit 1; }

docker network create --driver bridge public

#update OTK environment variable for MAC
dc_localIP=$(cat docker-compose-build-ssg.yml | grep OTK_SERVER_HOST | awk '{print $2}')
localIP=\"$(ifconfig en0 | grep inet | grep -v inet6 | awk '{print $2}')\"
[ $localIP != $dc_localIP ] && ( sed -i "" "s/$dc_localIP/$localIP/g" docker-compose-build-ssg.yml ; exit 1 )

#Start the API Gateway infrastruture with remote back end mysql
echo "Start the API MicroGateway backed by MySQL infrastruture"

docker-compose -f docker-compose-build-ssg.yml -f docker-compose.dockercloudproxy.yml up -d --build
ssg=$(docker-compose logs | grep "INFO: Server Started")
echo "- waiting for MicroGateway to start -"
while [[ !("$ssg" =~ "INFO: Server Started") ]]; do
    ssg=$(docker-compose logs | grep "INFO: Server Started")
    echo "- waiting for MicroGateway to start - $ssg"
    sleep 2
done


pushd ../external/otk/
docker-compose up --build -d

otk=$(docker-compose logs | grep "Gateway is now up and running\!")

echo "Looking to source control to deploy OTK policy"
while [[ !("$otk" =~ "Gateway is now up and running") ]]; do
    echo "- waiting for OAuth Server to start - $otk"
    otk=$(docker-compose logs | grep "Gateway is now up and running\!")
    sleep 2
done
./provision/add-otk-user.sh 127.0.0.1:8443 "admin" 'L7Secure$0@' "Gateway as a Client Identity Provider" "gw4ms.mycompany.com" "MIIDPjCCAiagAwIBAgIJAJxuJWOcosezMA0GCSqGSIb3DQEBCwUAMB4xHDAaBgNVBAMTE2d3NG1zLm15Y29tcGFueS5jb20wHhcNMTcwNTExMjE1OTA2WhcNMjIwNTEwMjE1OTA2WjAeMRwwGgYDVQQDExNndzRtcy5teWNvbXBhbnkuY29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEArpHuSAMvbYHICJYWYsfhUYex67ioOEl9+rFnHJGg8v+ghSbeZ5uxuGCE/eTkI7aVFwSGRP1mDjvCPDqheQabFtVNZC/T815enQV33TAULBCz5YLKu/I0ie9+4cCwseIIT6x5kTCAla/Ex7qgWoicppROCAuNjpuSFc3F0nA4QY8h26qMwlMdupeCrHcSj76uDfS86Vn9lf7Y3hz6jC1bO8mp95mMBTVW1JDQKcJvmPfFbBjHs146uA6umkwNqDBSYiwr1oBWZiiMIdCg/bnIZgq/IdTdGKt8739MuW9j5scCZtnn1F28WGGpIncxbGFHoZS5cOGdEbyY80RutWpv/wIDAQABo38wfTAdBgNVHQ4EFgQUuiSIW6OeLqqKQOFc42lqVqt+gacwTgYDVR0jBEcwRYAUuiSIW6OeLqqKQOFc42lqVqt+gaehIqQgMB4xHDAaBgNVBAMTE2d3NG1zLm15Y29tcGFueS5jb22CCQCcbiVjnKLHszAMBgNVHRMEBTADAQH/MA0GCSqGSIb3DQEBCwUAA4IBAQBRwh37Aq6o82mZXEhxaqqIRlTvK2DYjYZZmbzjCA8BAKVfAZDjPZtL/bdbQmU2oQwDpry6OHOfcoaTcTX+ZeGsWQz/Kb3g9zF9GansleYkayGGf5er9Ife7Mx9ODDg8NVdgJN8iNKjwDWz9IE9E1pIOKFbW1v/qwCMtkwhrw6pBfq39etH3aT7+TKd6YPjYekO49rpk5EAhSucxRAyGPX8JFO+YTEACkjKGUB4bgiG/0wdS/XnPkPmP/LmbN/9Pk0oAAdod1KhQ3NktnPBHfUUZwKXNzAciCi0ag2H6F0X3gragkw6en7FfGVY+hspupXuuhsYSjl8PjDoXpBsIMGk"

popd

#Start the backing MySQL databases
docker-compose -f docker-compose.LACDBINIT.yml up -d
docker-compose -f docker-compose.APIDATA.yml up -d

#Start the base LAC admin Infrastructure
echo "Start the LAC Admin Node infrastruture"
docker-compose -f docker-compose.LACINIT.yml up -d

#Wait for lac_admin_node to start to provision with and API
lacStartMsg=$(docker logs $(docker ps -q --filter="name=lacadmin_node") 2>&1 | grep "CA Live API Creator: REST service is starting")
echo "Looking for LAC Admin Node to start to deploy API Endpoint from source code control"
while [ "$lacStartMsg" != "CA Live API Creator: REST service is starting" ]; do
    echo "- waiting for LAC Admin Node to start - $lacStartMsg"
	lacStartMsg=$(docker logs $(docker ps -q --filter="name=lacadmin_node") 2>&1 | grep "CA Live API Creator: REST service is starting")
    sleep 5
done

#Deploy the Consul and Registrater Containers
echo "Deploying and configuring Consul Registry Infrastructure"
docker-compose -f docker-compose.MSREGISTRY.yml up -d

#Now start the scale node and have it attach to the cluster
echo "Start the LAC Scale Node"
docker-compose -f docker-compose.LACNODE.yml up -d

#Wait for lac_scale_node to start before scaling
lacStartMsg=$(docker logs $(docker ps -q --filter="name=lacscale_node") 2>&1 | grep "CA Live API Creator: REST service is starting")
echo "Waiting for single LAC Scale Node to start before scaling"
while [ "$lacStartMsg" != "CA Live API Creator: REST service is starting" ]; do
    echo "- waiting for LAC Scale Node to start - $lacStartMsg"
        lacStartMsg=$(docker logs $(docker ps -q --filter="name=lacscale_node") 2>&1 | grep "CA Live API Creator: REST service is starting")
    sleep 5
done

../GMU/./GatewayMigrationUtility.sh migrateIn -h localhost -p 443 -u admin --plaintextPassword password --trustCertificate --trustHostname --bundle ../GMU/BUNDLES/SPA-angular.min.js.xml --results ../GMU/OUT/SPA-angular.min.js.xml.results.xml
../GMU/./GatewayMigrationUtility.sh migrateIn -h localhost -p 443 -u admin --plaintextPassword password --trustCertificate --trustHostname --bundle ../GMU/BUNDLES/SPA-Recommendation.index.html.xml --results ../GMU/OUT/PA-Recommendation.index.html.xml.results.xml

echo "Deploying and configuring API Endpoint to LAC Admin node"

lacadmin login -u admin -p Password1 http://localhost:8111/ -a lac_cluster
lacadmin project import --file projectinit/recommendation.json
lacadmin datasource update --prefix rec --password root
lacadmin project import --file projectinit/customer_orders.json
lacadmin datasource update --prefix orders --password root

#Extra little pause to be sure
sleep 5

#Once Single scale node is up, add another for a total of 3 LAC nodes (1 Admin + 2 Scale)
echo "Scaling LAC Cluster to three nodes (1 Admin + 2 Scale) to start demo"
docker-compose -f docker-compose.LACNODE.yml scale lacscale_node=2
