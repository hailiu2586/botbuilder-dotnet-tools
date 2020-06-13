@echo off
setlocal
set BOT_PROJ=%1
if '%BOT_PROJ%'=='' set BOT_PROJ=%cd%
set BOT_PROJ

docker run --mount type=bind,source=%BOT_PROJ%,target=/bot -e AZ_SUB_ID=User-hailiu -e AZ_GROUP_NAME=va-test --restart on-failure:3 -it botbuild:0.0.4 /bin/bash --init-file /scripts/bootstrap.sh
