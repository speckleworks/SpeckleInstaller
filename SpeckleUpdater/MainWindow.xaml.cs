using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
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

      var installerPath = await Api.DownloadRelease(release.assets.First(x => x.name == Globals.InstallerName).browser_download_url);

      if (!File.Exists(installerPath))
      {
        this.Close();
        return;
      }

      //launch the just downloaded installer
      Process.Start(installerPath, "/SP- /VERYSILENT /SUPPRESSMSGBOXES /NOICONS");
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
  }
}
