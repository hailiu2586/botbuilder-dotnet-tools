#!/bin/bash

# config bf-cli for luis
bf config:set:luis --endpoint=$AZ_LUIS_API_ROOT --subscriptionKey=$AZ_LUIS_API_KEY --authoringKey=$AZ_LUIS_API_KEY
bf config:set:qnamaker --subscriptionKey=$AZ_QNA_SUB_KEY  --hostname=$AZ_QNA_HOSTNAME
