# ARM deployment template building blocks

1. [./insights.json](./insights.json) create shared app insights instance
1. [./luis.json](./luis.json) shared LUIS runtime and authoring accounts
1. [./qna.json](./qna.json) shared QnA search/site/account
1. [./role.json](./role.json) user assigned identity for bot build container with contributor (scoped to resource group) role
1. [./serverfarm.json](./serverfarm.json) create shared app service plan for hosting runtimes, bots and QnA
1. [./storage.json](./storage.json) storage account to hold bot built artifacts
1. [./topology.json](./topology.json) deployment manager artifact source, topology, service and service unit
