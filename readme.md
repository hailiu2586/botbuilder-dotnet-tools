# Microsoft.Bot.Builder.Tools

Helper routes for [Microsoft.Bot.Builder][bot-builder-git] based bot

1. /emulator to open livechat with installed bot emulator
1. /source to redirect to the git repo/commit that is deployed

## Get started

```bash
dotnet add {your-bot.csproj} package Microsoft.Bot.Builder.Tools
```

Update <code>Properties/launchSettings.json</code> to set launchUrl to '/emulator', like below.

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

[bot-builder-git]: https://github.com/microsoft/botbuilder-dotnet.git
