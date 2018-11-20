using System;
using System.Diagnostics;
using System.IO;
using System.Linq;
using static SpeckleUpdater.GitHub;

namespace SpeckleUpdater
{
  internal class Program
  {
    private static void Main(string[] args)
    {
      try
      {
        Initialize();
      }
      catch (Exception e)
      {
        Console.Write(e.Message);
      }
    }

    private static async void Initialize()
    {
      var release = await Api.GetLatestRelease();

      if (release == null)
      {
        return;
      }

      if (!UpdateAvailable(release))
      {
        return;
      }

      var installerPath = await Api.DownloadRelease(release.assets.First(x => x.name == Globals.InstallerName).url);

      if (!File.Exists(installerPath))
      {
        return;
      }

      //launch the just downloaded installer
      Process.Start(installerPath, "/SP- /VERYSILENT /SUPPRESSMSGBOXES /NOICONS");
    }

    private static bool UpdateAvailable(Release release)
    {
      var latest = Version.Parse(release.tag_name.Replace("v", ""));
      var current = System.Reflection.Assembly.GetExecutingAssembly().GetName().Version;

      if (current.CompareTo(latest) > 0)
      {
        return false;
      }

      if (!release.assets.Any(x => x.name == Globals.InstallerName))
      {
        return false;
      }

      return true;
    }

  }
}
