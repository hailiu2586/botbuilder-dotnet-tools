docker run -e AZ_SUB_ID=User-hailiu -e AZ_GROUP_NAME=va-test --restart on-failure:3 -it botbuild:0.0.3 /bin/bash --init-file /scripts/bootstrap.sh
