# Azure Bot Service Build Image

botbuild is docker image with az-cli and bf-cli pre-installed

## Get started

```bash
# build the docker image
docker build -t {repo}/botbuild:{tag} .
# run docker image with bootstrap that fetch storage and LUIS keys for bf-cli
docker run -e AZ_SUB_ID={azure_subscription_id} -e AZ_GROUP_NAME={resource_group_name} -it botbuild /bin/bash  --init-file /scripts/bootstrap.sh
# push docker image to docker hub
docker push {repo}/botbuild:{tag}
```
