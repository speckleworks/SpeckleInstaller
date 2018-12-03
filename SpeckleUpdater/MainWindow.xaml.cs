using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Windows;

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
      if (!File.Exists(_path) || !AlreadyDownloaded(release.Name))
      {
        await Api.DownloadRelease(release.Url, folder, _path);
      }
      //double check!
      if (!File.Exists(_path))
      {
        this.Close();
        return;
      }

      if (ProcessIsRunning("dynamo") || ProcessIsRunning("rhino") || ProcessIsRunning("revit"))
      {
        this.Show();
        UpdateMessage.Text = $"{Globals.AppName} {release.Name} is available! Do you want to install it now?";
      }
      else
      {
        //silent install
        Process.Start(_path, "/SP- /VERYSILENT /SUPPRESSMSGBOXES");
      }
    }

    private bool UpdateAvailable(Release release)
    {
      var latest = Version.Parse(release.Name.Replace("v", ""));
      var current = System.Reflection.Assembly.GetExecutingAssembly().GetName().Version;

      if (current.CompareTo(latest) >= 0)
      {
        return false;
      }

      return true;
    }

    private bool ProcessIsRunning(string name)
    {
      var processes = Process.GetProcesses();
      foreach (var p in processes)
      {
        if (p.ProcessName.ToLowerInvariant().Contains(name))
          return true;
      }
      return false;
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
