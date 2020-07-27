#!/bin/bash

# login with assigned identity if set
if [ "$AZ_USER_ASSIGNED_IDENTITY" = "" ]; then
    az login
else
    az login --identity
fi

# set az cloud related settings
export AZ_ARM_RESOURCE=`az cloud show --query endpoints.management --output tsv`
# set default susbscription
az account set -s $AZ_SUB_ID
# set default resource group
az configure --default group=$AZ_GROUP_NAME
# build run should take at most 2 hourse
export AZ_EXPIRY=$(date -d@"$(( `date +%s`+7200))" -u -Iseconds | sed -e s/UTC$/Z/g)
# get storage account id
export AZ_STORAGE_ACCOUNT=`az storage account list --query [0].id --output tsv`
# get storage account name
export AZ_STORAGE_ACCOUNT_NAME=`az storage account list --query [0].name --output tsv`
# get storage account key
export AZ_STORAGE_ACCOUNT_KEY=`az rest --method POST --uri $AZ_STORAGE_ACCOUNT/listKeys?api-version=2017-10-01 --query keys[0].value --output tsv`
# find storage end point
export AZ_BLOB_ROOT=`az storage account list --query [0].primaryEndpoints.blob --output tsv`
# get rw SAS token
export AZ_BLOB_SAS=`az storage account generate-sas --ids $AZ_STORAGE_ACCOUNT --expiry $AZ_EXPIRY --permissions wcar --resource-type o --services b --https-only --output tsv`
# get deployment artifacts SAS which has to include sv=2019-02-02
if [ "$ARTIFACTS_SASURI" = "" ]; then
    export ARTIFACTS_SASURI=`/scripts/generate-sas.sh artifacts`
fi
export ARTIFACTS_ROOT=`echo $ARTIFACTS_SASURI |  sed -e 's/^\(.*\)?.*$/\1/g'`
export ARTIFACTS_SAS=`echo $ARTIFACTS_SASURI | sed -e 's/^[^?]*?\(.*\)$/\1/g'`
# find LUIS.authoring account
export AZ_LUIS_ACCOUNT=`az cognitiveservices account list --query "[?kind=='LUIS.Authoring'].id|[0]" --output tsv`
# get LUIS api endpoint
export AZ_LUIS_API_ROOT=`az cognitiveservices account list --query "[?kind=='LUIS.Authoring'].endpoint|[0]" --output tsv`
# get LUIS authoring key
export AZ_LUIS_API_KEY=`az rest --uri $AZ_LUIS_ACCOUNT/listKeys?api-version=2017-04-18 --method POST --query key1 --output tsv`
# get LUIS runtime account
export AZ_LUIS_RUNTIME_ACCOUNT=`az cognitiveservices account list --query "[?kind=='LUIS'].name|[0]" --output tsv`
# set default BOT_ARTIFACT_SUFFIX to 'dev'
export BOT_ARTIFACT_SUFFIX=${BOT_ARTIFACT_SUFFIX:=dev}
# get QnA account
export AZ_QNA_ACCOUNT=`az cognitiveservices account list --query "[?kind=='QnAMaker'].id|[0]" --output tsv`
# get QnA endpoint key
export AZ_QNA_SUB_KEY=`az rest --uri $AZ_QNA_ACCOUNT/listKeys?api-version=2017-04-18 --method POST --query key1 --output tsv`
export AZ_QNA_HOSTNAME=`az rest --uri $AZ_QNA_ACCOUNT?api-version=2017-04-18 --method GET --query properties.apiProperties.qnaRuntimeEndpoint --output tsv`
# call bf-config to further setup bf-cli
/scripts/bf-config.sh
