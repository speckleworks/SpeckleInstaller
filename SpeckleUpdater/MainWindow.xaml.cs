using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Windows;
using static SpeckleUpdater.GitHub;

namespace SpeckleUpdater
{
  /// <summary>
  /// Interaction logic for MainWindow.xaml
  /// </summary>
  public partial class MainWindow : Window
  {
    public MainWindow()
    {
      InitializeComponent();
      this.Hide();
      CheckForUpdates();
    }

    private async void CheckForUpdates()
    {
      var release = await Api.GetLatestRelease();

      if (release == null)
      {
        this.Close();
        return;
      }

      if (!UpdateAvailable(release))
      {
        this.Close();
        return;
      }

      this.Show();

      var folder = Path.Combine(Path.GetTempPath(), Globals.AppName);
      var path = System.IO.Path.Combine(folder, Globals.InstallerName);

      //don't download if already there
      if(!File.Exists(path) || !IsSameVersion(release.tag_name))
      {
        await Api.DownloadRelease(release.assets.First(x => x.name == Globals.InstallerName).browser_download_url, folder, path);
      }

      if (!File.Exists(path))
      {
        this.Close();
        return;
      }

      MessageBoxResult response = MessageBox.Show("Speckle " + release.tag_name + " is available!\nDo you want to install it now?", "Speckle Updater (~˘▾˘)~", MessageBoxButton.YesNo, MessageBoxImage.Question, MessageBoxResult.Yes);
      if(response == MessageBoxResult.Yes)
      {
        //launch the installer
        Process.Start(path);
      }
      this.Close();
    }

    private bool UpdateAvailable(Release release)
    {
      var latest = Version.Parse(release.tag_name.Replace("v", ""));
      var current = System.Reflection.Assembly.GetExecutingAssembly().GetName().Version;

      if (current.CompareTo(latest) >= 0)
      {
        return false;
      }

      if (!release.assets.Any(x => x.name == Globals.InstallerName))
      {
        return false;
      }

      return true;
    }

    private bool IsSameVersion(string version)
    {
      var current = System.Reflection.Assembly.GetExecutingAssembly().GetName().Version;
      var v = Version.Parse(version.Replace("v", ""));
      if (current.CompareTo(v) == 0)
      {
        return true;
      }
      return false;
    }
  }
}
