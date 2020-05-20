using System;
using System.IO;
using System.Collections.Generic;
using System.Text;
using Microsoft.Build.Utilities;
using Newtonsoft.Json.Linq;
using static Microsoft.Bot.Builder.Tools.Build.GitExtensions;

namespace Microsoft.Bot.Builder.Tools.Build
{
    public class UpdateAppSettingsTask : Task
    {
        public string ProjectDirectory { get; set; }
        public string AppSettingsFile { get; set; }

        public override bool Execute()
        {
            var sourceUrl = GetSourceUrl(ProjectDirectory);
            if (string.IsNullOrEmpty(sourceUrl))
            {
                Log.LogWarning($"{ProjectDirectory} not a repo");
                return false;
            }
            Log.LogMessage($"set source url to {sourceUrl}");
            JObject settings = null;

            Log.LogMessage($"Opening {AppSettingsFile}");
            using (var stm = new FileStream(AppSettingsFile, FileMode.Open, FileAccess.Read))
            {
                Log.LogMessage($"read {AppSettingsFile}");
                using (var reader = new StreamReader(stm))
                {
                    var jsonText = reader.ReadToEnd();
                    settings = JObject.Parse(jsonText);
                    var prevValue = settings.SelectToken("AzureBotService/SourceUrl")?.Value<string>();
                    if (!string.IsNullOrEmpty(prevValue))
                    {
                        Log.LogMessage($"AzureBotService/SourceUrl already set to {prevValue}");
                        return false;
                    }
                    settings.Merge(JObject.FromObject(new { AzureBotService = new { SourceUrl = sourceUrl } }));
                }
            }

            var text = settings.ToString(Newtonsoft.Json.Formatting.Indented);
            using (var stm = new FileStream(AppSettingsFile, FileMode.OpenOrCreate, FileAccess.Write))
            {
                using (var writer = new StreamWriter(stm))
                {
                    writer.Write(text);
                    Log.LogMessage($"Written {AppSettingsFile} with \n{text}");
                }
            }

            return true;
        }
    }
}
