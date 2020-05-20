using Microsoft.VisualStudio.TestTools.UnitTesting;
using static Microsoft.Bot.Builder.Tools.Build.GitExtensions;

namespace Microsoft.Bot.Builder.Tools.Tests
{
    [TestClass]
    [TestCategory("Unit")]
    public class DevOptsTests
    {
        [DataTestMethod]
        [DataRow(@"c:\code\intercom\Intercom.DevPortal", "https://fuselabs.visualstudio.com/DefaultCollection/_git/Intercom?path=%2FIntercom.DevPortal&version=GBhailiu%2Fgrpc-glue")]
        [DataRow(@"D:\BotBuilder-Samples\samples\csharp_dotnetcore\adaptive-dialog\20.EchoBot-declarative", "https://github.com/microsoft/BotBuilder-Samples/tree/master/samples/csharp_dotnetcore/adaptive-dialog/20.EchoBot-declarative")]
        [DataRow(@"c:\code\intercom-master\Intercom.DevPortal", "https://fuselabs.visualstudio.com/DefaultCollection/_git/Intercom?path=%2FIntercom.DevPortal&version=GBhailiu%2Fdev-auth-test")]
        [DataRow(@"c:\scratch", null)]
        [DataRow(@"d:\work\Microsoft.Bot.Builder.Tools", null)]
        public void TestGitUrl(string dir, string gitUrl)
        {
            var url = GetSourceUrl(dir);
            Assert.AreEqual(gitUrl, url, url);
        }
    }
}
