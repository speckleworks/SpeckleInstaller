using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Threading.Tasks;
using static SpeckleUpdater.GitHub;

namespace SpeckleUpdater
{
  internal class Api
  {

    internal static async Task<Release> GetLatestRelease()
    {
      try
      {
        using (var client = new HttpClient())
        {
          client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
          client.DefaultRequestHeaders.UserAgent.Add(new ProductInfoHeaderValue("User-Agent", "speckle-updater"));

          // get the latest build on master
          using (var response = await client.GetAsync(Globals.LatestReopEndpoint))
          {
            response.EnsureSuccessStatusCode();

            var release = JsonConvert.DeserializeObject<Release>(await response.Content.ReadAsStringAsync());
            return release;
          }
        }
      }
      catch (Exception e)
      {
        Console.Write("Check for updates failed: " + e.Message);
        return null;
      }
    }

    internal static async Task<string> DownloadRelease(string url, string folder, string path)
    {
      try
      {

        if (!Directory.Exists(folder))
          Directory.CreateDirectory(folder);

        using (HttpClient client = new HttpClient())
        {
          client.Timeout = TimeSpan.FromMinutes(42);
          client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
          client.DefaultRequestHeaders.UserAgent.Add(new ProductInfoHeaderValue("User-Agent", "speckle-updater"));

          using (var response = await client.GetAsync(url))
          {
            response.EnsureSuccessStatusCode();

            if (response.IsSuccessStatusCode)
            {
              HttpContent content = response.Content;
              var contentStream = await content.ReadAsStreamAsync(); // get the actual content stream

              using (var fileStream = File.Create(path))
              {
                contentStream.Seek(0, SeekOrigin.Begin);
                contentStream.CopyTo(fileStream);
              }
            }
            else
            {
              throw new FileNotFoundException();
            }
          }

          return path;
        }
      }

      catch (Exception e)
      {
        Console.Write("Release download failed: " + e.Message);
        return null;
      }

    }


  }
}
