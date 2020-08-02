@echo off
setlocal
set BOT_PROJ=%1
if '%BOT_PROJ%'=='' set BOT_PROJ=%cd%
set BOT_PROJ
set SASURI=""
docker run --name botbuild --mount type=bind,source=%BOT_PROJ%,target=/bot -e AZ_SUB_ID=User-andreo -e AZ_GROUP_NAME=va-prod-test -e BOT_NAME=luis-qna-todo-bot -e QNA_BOT_NAME=TodoBotWithLuisAndQnA --restart on-failure:3 -it hailiu2586/botbuild:0.1.20 /bin/bash --init-file /scripts/bootstrap.sh
endlocal
