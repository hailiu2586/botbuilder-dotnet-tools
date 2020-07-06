#!/bin/bash
source /scripts/bootstrap.sh
echo Download bot artifacts
/scripts/download-artifacts.sh
echo Start building bot artifacts
/scripts/build-bot.sh
echo Upload bot runtime artifacts
/scripts/upload-artifacts.sh
echo Cloud bot build done
