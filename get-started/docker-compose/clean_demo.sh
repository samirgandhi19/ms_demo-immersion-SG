echo "stopping API MicroGateway"
docker-compose -f docker-compose.yml -f docker-compose.dockercloudproxy.yml down --volumes
echo "API MicroGateway stopped"

docker-compose -f docker-compose.LACDBINIT.yml down --volumes
docker-compose -f docker-compose.APIDATA.yml down --volumes
docker-compose -f docker-compose.LACINIT.yml down --volumes
docker-compose -f docker-compose.LACNODE.yml down --volumes
docker-compose -f docker-compose.MSREGISTRY.yml down --volumes

cd ../external/otk/
docker-compose down --volumes

#docker ps -a -f network=microservice |grep -v STATUS | awk '{print $1}' | xargs docker rm -f
#docker images | grep darrinsolomon | awk '{print $3}' | xargs docker rmi
docker network rm public
