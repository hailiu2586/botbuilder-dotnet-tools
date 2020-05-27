using System;
using System.IO;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using LibGit2Sharp;
using static Microsoft.Bot.Builder.Tools.Build.GitExtensions;
using System.Threading.Tasks;
using System.Threading;

namespace Microsoft.Bot.Builder.Tools.Tests
{
    [TestClass]
    [TestCategory("Unit")]
    public class DevOptsTests
    {
        private string _repoDirectory;

        [TestInitialize]
        public void Setup()
        {
            _repoDirectory = Path.Combine(Path.GetTempPath(), $"{Path.GetRandomFileName()}");
            Directory.CreateDirectory(_repoDirectory);
        }

        [TestCleanup]
        public async Task Cleanup()
        {
            await Retry(3, TimeSpan.FromSeconds(3), () =>  {
                var dir = new DirectoryInfo(_repoDirectory);
                foreach (var file in dir.GetFileSystemInfos("*", SearchOption.AllDirectories))
                {
                    file.Attributes = FileAttributes.Normal;
                }
                Directory.Delete(_repoDirectory, recursive: true);
                return Task.CompletedTask;
            });
        }

        [DataTestMethod]
        [DataRow(null, null, null)]
        [DataRow("https://github.com/hailiu2586/botbuilder-dotnet-tools.git", "https://github.com/hailiu2586/botbuilder-dotnet-tools/tree/master", null)]
        [DataRow("https://github.com/hailiu2586/botbuilder-dotnet-tools.git", "https://github.com/hailiu2586/botbuilder-dotnet-tools/tree/master/Web", "Web")]
        [DataRow("https://dev.azure.com/hailiu0869/hello-dot-net/_git/hello-dot-net", "https://dev.azure.com/hailiu0869/hello-dot-net/_git/hello-dot-net", null)]
        public void TestGitUrl(string init, string gitUrl, string folder)
        {
            if (!string.IsNullOrEmpty(init))
            {
                Repository.Clone(init, _repoDirectory);
            }

            var directory = string.IsNullOrEmpty(folder) ? _repoDirectory : $"{_repoDirectory}{Path.DirectorySeparatorChar}{folder}";
            var url = GetSourceUrl(directory);
            Assert.AreEqual(gitUrl, url, url);
        }

        private static async Task Retry(int max, TimeSpan wait, Func<Task> action)
        {
            var cur = 0;

            for(;;)
            {
                try
                {
                    await action().ConfigureAwait(false);
                    break;
                }
                catch (Exception)
                {
                    cur++;
                    if (cur >= max)
                    {
                        throw;
                    }
                    await Task.Delay(wait).ConfigureAwait(false);
                }
            }
        }
    }
}
