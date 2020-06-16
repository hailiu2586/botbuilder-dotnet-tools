#!/bin/bash

# download artifacts
if [ "$AZ_STORAGE_ACCOUNT" = ""]; then
   echo AZ_STORAGE_ACCOUNT not specified
   exit
fi

# download artifact zip
mkdir -p $(dirname /zip/$BOT_ARTIFACT)
curl -f -o /zip/$BOT_ARTIFACT "$AZ_BLOB_ROOT"artifacts/$BOT_ARTIFACT?$AZ_BLOB_SAS

# unzip
unzip /zip/$BOT_ARTIFACT -d /bot
