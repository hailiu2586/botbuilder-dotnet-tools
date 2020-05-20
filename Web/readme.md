# Microsoft.Bot.Builder.Tools.Web

Helper routes for [Microsoft.Bot.Builder][bot-builder-git] based bot

1. /emulator to open livechat with installed bot emulator
1. /source to redirect to the git repo/commit that is deployed

## Get started

```bash
dotnet add {your-bot.csproj} package Microsoft.Bot.Builder.Tools.Web
```

Update <code>Properties/launchSettings.json</code> to set <code>launchUrl</code> to <code>'emulator'</code>, like below.

```json
{
    "profiles": {
        "IIS Express": {
        "commandName": "IISExpress",
        "launchBrowser": true,
        "launchUrl": "emulator",
        "environmentVariables": {
            "ASPNETCORE_ENVIRONMENT": "Development"
        }
    }
}
```
## Set source url in appSettings.json

Add the following section to the <code>appSettings.json</code> to set the redirect target of route <code>'/source'</code>
```json
{
    "AzureBotService": {
        "SourceUrl": "{URL to the source files of the bot}"
    }
}
```

## Set source url automatically

```bash
dotnet add {your-bot.csproj} package Microsoft.Bot.Builder.Tools.Build
dotnet publish {your-bot.csproj}
```

The above script with install a build target that will extract the current repository and branch info and inject it in
<code>appSettings.json</code> if it is not set manually already.


[bot-builder-git]: https://github.com/microsoft/botbuilder-dotnet.git
