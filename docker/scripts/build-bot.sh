#!/bin/bash
pushd /bot
mkdir -p /bot/Dialogs/generated
# call luis:build
echo Start building any LUIS artifacts
bf luis:build -i /bot/Dialogs -o /bot/Dialogs/generated --botName=$BOT_NAME --defaultCulture=en-us
# flatten out qna files into /bot/Dialogs/qna-staging
echo Start building any QnA artifacts
mkdir -p /bot/Dialogs/_qna-staging
find /bot/Dialogs -type f -name '*.qna' -print0 | xargs -0 -i -n 1 cp -f {} /bot/Dialogs/_qna-staging/
# for each .qna file, build the qna dialog
find /bot/Dialogs/_qna-staging -type f -name '*.qna' -print0 | xargs -0 -i -t -n 1 /scripts/build-qna.sh {}
# clean up qna staging directory
rm -rf /bot/Dialogs/_qna-staging
popd
