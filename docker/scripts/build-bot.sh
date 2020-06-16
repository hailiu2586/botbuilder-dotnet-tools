#!/bin/bash
pushd /bot
mkdir -p /bot/Dialogs/generated
# call luis:build
bf luis:build -i /bot/Dialogs -o /bot/Dialogs/generated --botName=$BOT_NAME --defaultCulture=en-us
popd
