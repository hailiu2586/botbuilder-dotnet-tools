#!/bin/bash

# download artifacts
if [ "$AZ_STORAGE_ACCOUNT" = ""]; then
   echo AZ_STORAGE_ACCOUNT not specified
   exit
fi

BOT_BUILT_ARTIFACT=${BOT_ARTIFACT%.zip}-built-$BOT_ARTIFACT_SUFFIX.zip
# zip /bot ot new zip
mkdir -p /built
touch /built/bot-build.zip
rm /built/bot-build.zip
pushd /bot
zip -r /built/bot-build.zip .
popd

# upload the bob-build.zip to storage blob
az storage blob upload --container-name artifacts --name $BOT_BUILT_ARTIFACT --file /built/bot-build.zip --account-name $AZ_STORAGE_ACCOUNT_NAME

# update the bot web app with the new zip package
echo Update bot app runtime
/scripts/update-botapp.sh $BOT_BUILT_ARTIFACT
