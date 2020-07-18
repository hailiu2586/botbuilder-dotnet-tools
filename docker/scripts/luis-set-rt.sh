#!/bin/bash
# assgin luis run time azure account to luis app
appId=$1
LUIS_API_HEADERS="Ocp-Apim-Subscription-Key=${AZ_LUIS_API_KEY} Content-Type=application/json"
az rest --method POST --uri $AZ_LUIS_API_ROOT/luis/api/v2.0/apps/$appId/azureaccounts --resource $AZ_ARM_RESOURCE --headers $LUIS_API_HEADERS --body @/bot/Dialogs/generated/luis.runtime.json --query code --output tsv
# sleep 1.5 seconds to spread out load
sleep 1.5
