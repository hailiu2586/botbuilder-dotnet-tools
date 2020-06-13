#!/bin/bash

# config bf-cli for luis
bf config:set:luis --endpoint=$AZ_LUIS_API_ROOT --subscriptionKey=$AZ_LUIS_API_KEY --authoringKey=$AZ_LUIS_API_KEY
