# Speckle Installer

[![Build status](https://ci.appveyor.com/api/projects/status/pkdn8l2bumxy3esa/branch/master?svg=true)](https://ci.appveyor.com/project/SpeckleWorks/speckleinstaller) ![GitHub All Releases](https://img.shields.io/github/downloads/speckleworks/speckleinstaller/total)

![image](https://user-images.githubusercontent.com/2679513/48942587-fba54a00-ef17-11e8-8708-65f6be50ebe0.png) 

Speckle desktop client installer for:

- Grasshopper
- Rhino
- Dynamo
- (NEW) [SpeckleCoreGeometry](https://github.com/speckleworks/SpeckleCoreGeometry) 

The installer does not require admin privileges and auto updates!

## Creating a new (pre) release

1. Change version in `appveyor.yml` file
2. Commit & tag commit with the new version
3. Push to origin

To push the newly minted pre-release, you'll need to edit it and change its status from `prerelease` to `release`.

## Installer tool
This project uses [Inno Setup](http://www.jrsoftware.org/) to create the installer.

If you'd like to contribute to the project, please first head over to [Inno Setup download page](http://www.jrsoftware.org/isdl.php) and install it. 
