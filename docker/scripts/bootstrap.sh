#!/bin/bash

# login with assigned identity if set
if [ "$AZ_USER_ASSIGNED_IDENTITY" = "" ]; then
    az login
else
    az login --identity
fi
# set default susbscription
az account set -s $AZ_SUB_ID
# set default resource group
az configure --default group=$AZ_GROUP_NAME
# build run should take at most 2 hourse
export AZ_EXPIRY=$(date -d@"$(( `date +%s`+7200))" -u -Iseconds | sed -e s/UTC$/Z/g)
# get storage account id
export AZ_STORAGE_ACCOUNT=`az storage account list --query [0].id --output tsv`
# find storage end point
export AZ_BLOB_ROOT=`az storage account list --query [0].primaryEndpoints.blob --output tsv`
# get rw SAS token
export AZ_BLOB_SAS=`az storage account generate-sas --ids $AZ_STORAGE_ACCOUNT --expiry $AZ_EXPIRY --permissions wcar --resource-type o --services b --https-only`
# find LUIS.authoring account
export AZ_LUIS_ACCOUNT=`az cognitiveservices account list --query "[?kind=='LUIS.Authoring'].id|[0]" --output tsv`
# get LUIS api endpoint
export AZ_LUIS_API_ROOT=`az cognitiveservices account list --query "[?kind=='LUIS.Authoring'].endpoint|[0]" --output tsv`
# get LUIS authoring key
export AZ_LUIS_API_KEY=`az rest --uri $AZ_LUIS_ACCOUNT/listKeys?api-version=2017-04-18 --method POST --query key1 --output tsv`
# call bf-config to further setup bf-cli
/scripts/bf-config.sh
