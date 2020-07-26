#!/bin/bash
# generate sas with specific sv using storage key and hmac
BLOB_PATH=$1
BLOB_ACCESS=$2
BLOB_RESOURCE=$3
SV=$4
BLOB_EXPIRY=$5

if [ "$BLOB_ACCESS" = "" ]; then
    BLOB_ACCESS=rl
fi

if [ "$BLOB_RESOURCE" == "" ]; then
    BLOB_RESOURCE=c
fi

if [ "$SV" = "" ]; then
    SV=2019-02-02
fi

BLOB_START=`date -u -Idate`
if [ "$BLOB_EXPIRY" = "" ]; then
    # expire in 10 years
    BLOB_EXPIRY=$(date -d@"$(( `date +%s`+(10*365*24*3600)))" -u -Idate)
fi

BLOB_Canonicalizedresource=/blob/$AZ_STORAGE_ACCOUNT_NAME/$BLOB_PATH

# https://docs.microsoft.com/en-us/rest/api/storageservices/create-service-sas#version-2018-11-09-and-later
STS=`printf "$BLOB_ACCESS\n$BLOB_START\n$BLOB_EXPIRY\n$BLOB_Canonicalizedresource\n\n\n\n$SV\n$BLOB_RESOURCE\n\n\n\n\n\n"`
HEXKEY=`echo $AZ_STORAGE_ACCOUNT_KEY | base64 -d | xxd -p -c256 | sed -e s/[:[space]:]*//g`
SIG=`printf "$BLOB_ACCESS\n$BLOB_START\n$BLOB_EXPIRY\n$BLOB_Canonicalizedresource\n\n\n\n$SV\n$BLOB_RESOURCE\n\n\n\n\n\n" | openssl sha256 -binary -mac hmac -macopt hexkey:$HEXKEY | base64 | sed -e 's/=/%3D/g' | sed -e 's/+/%2B/g' | sed -e 's/\\//%2F/g'`
SAS="$AZ_BLOB_ROOT$BLOB_PATH?sv=$SV&sp=$BLOB_ACCESS&sr=$BLOB_RESOURCE&st=$BLOB_START&se=$BLOB_EXPIRY&sig=$SIG"
echo $SAS
