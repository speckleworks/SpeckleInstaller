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
    
  private string _path = "";

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

      var folder = Path.Combine(Path.GetTempPath(), Globals.AppName);
      _path = Path.Combine(folder, Globals.InstallerName);

      //don't download if already there
      if (!File.Exists(_path) || !AlreadyDownloaded(release.tag_name))
      {
        await Api.DownloadRelease(release.assets.First(x => x.name == Globals.InstallerName).browser_download_url, folder, _path);
      }
      //double check!
      if (!File.Exists(_path))
      {
        this.Close();
        return;
      }
      this.Show();
      UpdateMessage.Text = $"Speckle {release.tag_name} is available! Do you want to install it now?";
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


    private bool AlreadyDownloaded(string version)
    {
      FileVersionInfo fileInfo = FileVersionInfo.GetVersionInfo(_path);
      var v = Version.Parse(version.Replace("v", ""));
      var current = Version.Parse(fileInfo.FileVersion);
      if (current.CompareTo(v) == 0)
      {
        return true;
      }
      return false;
    }

    private void Yes_Click(object sender, RoutedEventArgs e)
    {
      Process.Start(_path);
      this.Close();
    }

    private void No_Click(object sender, RoutedEventArgs e)
    {
      this.Close();
    }
  }
}
