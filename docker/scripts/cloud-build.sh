#!/bin/bash
source /scripts/bootstrap.sh
/scripts/download-artifacts.sh
/scripts/build-bot.sh
/scripts/upload-artifacts.sh
