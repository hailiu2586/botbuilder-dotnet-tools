using System;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using LibGit2Sharp;

namespace Microsoft.Bot.Builder.Tools.Build
{
    public static class GitExtensions
    {
        /// <summary>
        /// Get the Git repo url that can be loaded in a browser to show the
        /// the source files pointed in 'dirPath'
        /// </summary>
        /// <param name="dirPath"></param>
        /// <returns>absolute url points to the remote origin and tree path</returns>
        public static string GetSourceUrl(string dirPath)
        {
            var repoDir = FindRepoRoot(dirPath);
            if (string.IsNullOrEmpty(repoDir))
            {
                return null;
            }

            var repo = new Repository(repoDir);
            var remoteUrl = repo.RemoteOrigin();

            if (string.IsNullOrEmpty(remoteUrl))
            {
                return null;
            }

            var baseUri = remoteUrl.AsHttpsGitUrl();
            var relPath = dirPath.Substring(repoDir.Length + 1);
            var branch = repo.Head.FriendlyName;

            if (baseUri.IsGithubUri())
            {
                relPath = $"/tree/{branch}/{relPath}";
            }

            if (baseUri.IsVsoUri())
            {
                relPath = $"?path={Uri.EscapeDataString("/" + relPath)}&version=GB{Uri.EscapeDataString(branch)}";
            }

            return new Uri($"{baseUri.AbsoluteUri}{relPath}").AbsoluteUri;
        }

        public static bool IsGitProtocol(this string repoUrl) => repoUrl.StartsWith("git@");
        public static bool IsGitHubGitUrl(this string repoUrl) => repoUrl.StartsWith("git@github.com");
        public static bool IsWorktree(this Repository repo) => repo.Info.Path.IndexOf($".git{Path.DirectorySeparatorChar}worktrees") >= 0;
        public static string RemoteOrigin(this Repository repo)
        {
            if (!repo.IsWorktree())
            {
                return repo.Config.Get<string>("remote.origin.url".Split('.'))?.Value;
            }

            var repoPath = repo.Info.Path;
            var gitRootPos = repoPath.IndexOf(".git");
            var realRepo = new Repository(repoPath.Substring(0, gitRootPos));
            return realRepo.RemoteOrigin();
        }

        private static Regex gitProtocolParts = new Regex("^git@(?<host>[^:]+):(?<namespace>[^\\/]+){0,1}(?<repo>.*)\\.git$");

        private static bool IsGithubUri(this Uri uri) => uri.Host == "github.com";
        private static bool IsVsoUri(this Uri uri) => uri.Host.EndsWith(".visualstudio.com");

        public static Uri AsHttpsGitUrl(this string repoUrl) {
            if (repoUrl.StartsWith("https://"))
            {
                return new Uri(repoUrl);
            }

            var match = gitProtocolParts.Match(repoUrl);
            if (match != null)
            {
                return new Uri($"https://{match.Groups["host"]}/{match.Groups["namespace"]}{match.Groups["repo"]}");
            }

            return null;
        }

        public static string FindRepoRoot(string direPath)
        {
            var curPath = direPath;

            while (!string.IsNullOrEmpty(curPath) &&
                !Directory.Exists(Path.Combine(curPath, ".git")) &&
                !File.Exists(Path.Combine(curPath, ".git")))
            {
                var parent = Directory.GetParent(curPath);
                curPath = parent?.FullName;
            }

            return curPath;
        }
    }
}
