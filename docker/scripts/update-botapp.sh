#!/bin/bash
BOT_BUILT_ARTIFACT=$1
if [ "$BOT_BUILT_ARTIFACT" == '' ]; then
   echo BOT_BUILT_ARTIFACT not specified
   exit
fi

# expire in 2 years
BOT_ZIP_EXPIRY=$(date -d@"$(( `date +%s`+(2*365*24*3600)))" -u -Idate)
BOT_ZIP_SAS_URL=`az storage blob generate-sas --account-name  $AZ_STORAGE_ACCOUNT_NAME --container-name artifacts --name $BOT_BUILT_ARTIFACT --expiry $BOT_ZIP_EXPIRY --permissions r --full-uri --https-only --output tsv`;
echo set $BOT_WEB_APP WEBSITE_RUN_FROM_PACKAGE
az webapp config appsettings set --name $BOT_WEB_APP --settings WEBSITE_RUN_FROM_PACKAGE=$BOT_ZIP_SAS_URL
