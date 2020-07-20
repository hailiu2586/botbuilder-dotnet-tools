#!/bin/bash
pushd /bot
echo Create /bot/Dialogs/generated
mkdir -p /bot/Dialogs/generated

# cross train QnA
pushd /bot/Dialogs
echo Cross train LU and QnA
CROSS_TRAIN_CONFIG=`find . -type f -name 'Dialog*Hierarchy*.json'`
bf luis:cross-train -i . -o /bot/Dialogs/generated --config=$CROSS_TRAIN_CONFIG
popd

# call luis:build
echo Start building any LUIS artifacts
bf luis:build -i /bot/Dialogs/generated -o /bot/Dialogs/generated --botName=$BOT_NAME --defaultCulture=en-us

# create luis.keys.json
echo Create luis.keys.json and assing luis runtime accounts
LUIS_ACCOUNT=`az cognitiveservices account list  --query "[?kind=='LUIS']|[0].id" --output tsv`
{ az cognitiveservices account list  --query "[?kind=='LUIS']|[0].{LuisAPIHostName:endpoint}"; az rest --uri $LUIS_ACCOUNT/listKeys?api-version=2017-04-18 --method POST --query "{LuisAPIKey:key1}"; }  | jq -s '.[0] * .[1]' > /bot/Dialogs/generated/luis.key.json

# create luis runtime settings json
echo {} | jq ".azureSubscriptionId=\"`az account show --query id --output tsv`\"" | jq ".resourceGroup=\"$AZ_GROUP_NAME\"" | jq ".accountName=\"$AZ_LUIS_RUNTIME_ACCOUNT\"" > /bot/Dialogs/generated/luis.runtime.json
# assign luis runtime account to apps
cat /bot/Dialogs/generated/luis.settings.root.westus.json | jq -r .luis[] | xargs -i -t /scripts/luis-set-rt.sh {}

# build qna KB
echo Start building any QnA artifacts
bf qnamaker:build -i /bot/Dialogs/generated -o /bot/Dialogs/generated --botName=$QNA_BOT_NAME --defaultCulture=en-us --subscriptionKey $AZ_QNA_SUB_KEY --log

# create qna.keys.json
QNA_API_HOST=https://`az rest --output tsv --query location --uri $AZ_QNA_ACCOUNT?api-version=2017-04-18`.api.cognitive.microsoft.com
QNA_ENDPOINT_KEY=`curl $QNA_API_HOST/qnamaker/v4.0/endpointkeys -H "Ocp-Apim-Subscription-Key: $AZ_QNA_SUB_KEY" | jq .primaryEndpointKey`
echo {} | jq ".QnAHostName=\"$AZ_QNA_HOSTNAME/qnamaker\"" | jq ".QnAEndpointKey=${QNA_ENDPOINT_KEY}"  > /bot/Dialogs/generated/qna.key.json

popd
