#!/bin/bash
pushd /bot
mkdir -p /bot/Dialogs/generated
# call luis:build
echo Start building any LUIS artifacts
bf luis:build -i /bot/Dialogs -o /bot/Dialogs/generated --botName=$BOT_NAME --defaultCulture=en-us

# create luis.keys.json
LUIS_ACCOUNT=`az cognitiveservices account list  --query "[?kind=='LUIS']|[0].id" --output tsv`
{ az cognitiveservices account list  --query "[?kind=='LUIS']|[0].{LuisAPIHostName:endpoint}"; az rest --uri $LUIS_ACCOUNT/listKeys?api-version=2017-04-18 --method POST --query "{LuisAPIKey:key1}"; }  | jq -s '.[0] * .[1]' > /bot/Dialogs/generated/luis.key.json

# flatten out qna files into /bot/Dialogs/qna-staging
echo Start building any QnA artifacts
mkdir -p /bot/Dialogs/_qna-staging
find /bot/Dialogs -type f -name '*.qna' -print0 | xargs -0 -i -n 1 cp -f {} /bot/Dialogs/_qna-staging/
# build qna KB
bf qnamaker:build -i /bot/Dialogs/_qna-staging -o /bot/Dialogs/generated --botName=$QNA_BOT_NAME --defaultCulture=en-us --subscriptionKey $AZ_QNA_SUB_KEY --log
# for each .qna file, build the qna dialog
#find /bot/Dialogs/_qna-staging -type f -name '*.qna' -print0 | xargs -0 -i -t -n 1 /scripts/build-qna.sh {}

# create qna.keys.json
QNA_API_HOST=https://`az rest --output tsv --query location --uri $AZ_QNA_ACCOUNT?api-version=2017-04-18`.api.cognitive.microsoft.com
QNA_ENDPOINT_KEY=`curl $QNA_API_HOST/qnamaker/v4.0/endpointkeys -H "Ocp-Apim-Subscription-Key: $AZ_QNA_SUB_KEY" | jq .primaryEndpointKey`
echo {} | jq ".QnAHostName=\"$AZ_QNA_HOSTNAME/qnamaker\"" | jq ".QnAEndpointKey=${QNA_ENDPOINT_KEY}"  > /bot/Dialogs/generated/qna.key.json

# clean up qna staging directory
rm -rf /bot/Dialogs/_qna-staging
popd
