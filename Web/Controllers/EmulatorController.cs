using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http.Extensions;
using Microsoft.AspNetCore.Mvc;
using Microsoft.BotBuilder.Tools.Models;

namespace Microsoft.BotBuilder.Tools.Controllers
{
    [Route("{controller}")]
    public class EmulatorController : Controller
    {
        [HttpGet]
        public ActionResult Index()
        {
            var host = new Uri(Request.GetEncodedUrl()).GetLeftPart(UriPartial.Authority);
            var emulator = new EmulatorModel
            {
                OpenUrl = $"bfemulator://livechat?botUrl={host}/api/messages",
                DownloadUrl = "https://github.com/microsoft/BotFramework-Emulator/releases"
            };

            //return new RedirectResult($"bfemulator://livechat?botUrl={host}/api/messages");
            return View(emulator);
        }
    }
}
