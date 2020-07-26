@echo off
setlocal
set BOT_PROJ=%1
if '%BOT_PROJ%'=='' set BOT_PROJ=%cd%
set BOT_PROJ

docker run --mount type=bind,source=%BOT_PROJ%,target=/bot -e AZ_SUB_ID=User-hailiu -e AZ_GROUP_NAME=va-test -e BOT_NAME=luis-qna-todo-bot -e QNA_BOT_NAME=TodoBotWithLuisAndQnA --restart on-failure:3 -it hailiu2586/botbuild:0.1.18 /bin/bash --init-file /scripts/bootstrap.sh
endlocal
