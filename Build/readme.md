# Microsoft.Bot.Builder.Tools.Build

MSBuild build targets to support deploying Azure bot services built with the [dotnet-sdk]

## Get started

```bash
dotnet add {your-bot.csproj} package Microsoft.Bot.Builder.Tools.Build
```

This injects the following build targets into the bot csproj:

1. <code>ZipPublishFolder</code>: run as part of <code>dotnet publish</code> to create a zip file for the <code>publish</code> folder.

   this can be used later by [az-cli-botApp] for bot deployment

1. <code>SetSourceUrl</code>: run as part of <code>dotnet build</code> to extract the current source repository url (including branch info) and inject it into the built
   <code>appSettings.json</code> to be used by [Microsoft.Bot.Builder.Tools.Web] route '/source'

   Only Windows x64 platform is supported for now until we work through cross-platform issue with [LibGit2Sharp.NativeBinaries]

[dotnet-sdk]: https://www.nuget.org/packages/Microsoft.Bot.Builder
[az-cli-botApp]: ../Botappextension
[Microsoft.Bot.Builder.Tools.Web]: ../Web
[LibGit2Sharp.NativeBinaries]: https://www.nuget.org/packages/LibGit2Sharp.NativeBinaries/
