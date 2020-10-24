# Micrsooft.Bot.Builder.Tools

Dotnet core developer tools to make building and deploying Azure Bot Services friction free. Here are addon NuGet packages and extensions that will make Dotnet core developers more productive at building and deploying Azure Bot Services.

## Demo project

https://github.com/microsoft/BotBuilder-Samples/tree/hailiu/arm-deploy/samples/csharp_dotnetcore/adaptive-dialog/20.EchoBot-declarative

## F5 just works

```bash
dotnet add package Microsoft.Bot.Builder.Tools.Web
```

This adds a new route <code>/emulator</code> to the bot project and with <code>launchUrl</code> in <code>launchSettings.json</code> set will make <code>F5</code> from Visual Studio launch the livechat in [Bot-Emulator]

See [Microsoft.Bot.Builder.Tools.Web](./Web/readme.md) for details

## Source code just works

```bash
dotnet add package Microsoft.Bot.Builder.Tools.Build
```

This adds build targets to will auto update the published <code>appSettings.json</code> that will let the bot project rediret route <code>'/source'</code> to any source code hosting repo


See [Microsoft.Bot.Builder.Tools.Web](./Web/readme.md) for details

## Deploy just works

```bash
az extension add --source Botappextension/dist/botappextension-0.0.2-py2.py3-none-any.whl
```

This add custom <code>az-cli</code> to make deploying Dotnet core bot to web app a simple code

See [Az-Cli-BotApp-Extension](./Botappextension/readme.md) for details
