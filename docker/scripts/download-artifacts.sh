#!/bin/bash

# download artifacts
if [ "$AZ_STORAGE_ACCOUNT" = "" ]; then
   echo AZ_STORAGE_ACCOUNT not specified
   exit
fi

# download artifact zip
mkdir -p $(dirname /zip/$BOT_ARTIFACT)
ZIP_URL=$ARTIFACTS_ROOT/templates/$BOT_ARTIFACT?$ARTIFACTS_SAS
echo downloading ZIP_URL=$ZIP_URL
curl -f -o /zip/$BOT_ARTIFACT $ZIP_URL

# unzip
unzip /zip/$BOT_ARTIFACT -d /bot > /dev/null
