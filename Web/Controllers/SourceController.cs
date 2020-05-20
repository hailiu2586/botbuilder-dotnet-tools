using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http.Extensions;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;

namespace Microsoft.BotBuilder.Tools.Controllers
{
    [Route("{controller}")]
    public class SourceController : Controller
    {
        private readonly IConfiguration _config;

        public SourceController(IConfiguration config)
        {
            _config = config;
        }

        [HttpGet]
        public ActionResult Index()
        {
            if (string.IsNullOrWhiteSpace(SourceUrl))
            {
                return View();
            }
            return new RedirectResult(SourceUrl);
        }

        private string SourceUrl => _config.GetSection("AzureBotService").GetSection("SourceUrl").Value;
    }
}