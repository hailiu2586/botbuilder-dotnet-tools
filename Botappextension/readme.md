# AZ-cli botapp extension

<code>az-cli</code> extension that host <code>botapp</code> commmand group to help with deploying Azure Bot Service for dotnet core developers.

## Get started

```bash
# install the az-cli extension
az extension add --source dist/botappextension-0.0.2-py2.py3-none-any.whl
# create the zip file to deploy
dotnet publish
# deploy dotnet core bot project
az botapp deploy -n {botId} -s {subscriptionId} --resource-group {groupName} --src {path_to_zip_file}
```

## Deploy command

The deploy command does the following steps to deploy the bot:

1. find the bot resource through botId
1. find the hosting web app through the <code>hostedBy</code> tag on the bot resource
1. find the staging slot for the webapp and clean it up for code deployment
1. deploy the zip package to the staging slot
1. swap the staging slot into production


```bash
Command
    az botapp deploy

Arguments
    --src    [Required] : Zip file to deploy.

Resource Id Arguments
    --ids               : One or more resource IDs (space-delimited). It should be a complete
                          resource ID containing all information of 'Resource Id' arguments. If
                          provided, no other 'Resource Id' arguments should be specified.
    --name -n           : Bot Id to deploy.
    --resource-group -g : Name of resource group. You can configure the default group using `az
                          configure --defaults group=<name>`.  Default: hailiuprodbots.
    --subscription      : Name or ID of subscription. You can configure the default subscription
                          using `az account set -s NAME_OR_ID`.

Global Arguments
    --debug             : Increase logging verbosity to show all debug logs.
    --help -h           : Show this help message and exit.
    --output -o         : Output format.  Allowed values: json, jsonc, none, table, tsv, yaml,
                          yamlc.  Default: json.
    --query             : JMESPath query string. See http://jmespath.org/ for more information and
                          examples.
    --verbose           : Increase logging verbosity. Use --debug for full debug logs.
```

## Integrate with CI/CD

Since this is an <code>az-cli</code> extension, it can be easily integrated into any DevOps pipeline with <code>az-cli</code> support which includes [Azure DevOps][Azure-DevOps-Az-Cli]


[Azure-DevOps-Az-Cli]: https://docs.microsoft.com/en-us/azure/devops/pipelines/tasks/deploy/azure-cli?view=azure-devops
