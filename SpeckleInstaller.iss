;defining variables
#define AppName      "Speckle"
#define AppVersion GetFileVersion("SpeckleUpdater\bin\Release\SpeckleUpdater.exe")
#define RhinoVersion  GetFileVersion("SpeckleRhino\SpeckleRhinoConverter.dll")
#define DynamoVersion  GetFileVersion("SpeckleDynamo\bin\SpeckleDynamo.dll")
#define RevitVersion  GetFileVersion("SpeckleRevit2021\SpeckleRevit.dll")
#define CoreGeometryVersion  GetFileVersion("SpeckleCoreGeometry\SpeckleCoreGeometry.dll")
#define SpeckleElementsVersion  GetFileVersion("SpeckleElements\SpeckleElements.dll")
#define SpeckleStructuralVersion  GetFileVersion("SpeckleStructural\SpeckleStructural.dll")
#define AppPublisher "Speckle"
#define AppURL       "https://speckle.works"
#define SpeckleFolder "{localappdata}\Speckle"      
#define UpdaterFilename       "SpeckleUpdater.exe"

[Setup]
AppId={{BA3A01AA-F70D-4747-AA0E-E93F38C793C8}
AppName={#AppName}
AppVersion={#AppVersion}
AppVerName={#AppName} {#AppVersion}
AppPublisher={#AppPublisher}
AppPublisherURL={#AppURL}
AppSupportURL={#AppURL}
AppUpdatesURL={#AppURL}
DefaultDirName={#SpeckleFolder}
DisableDirPage=yes
DefaultGroupName={#AppName}
DisableProgramGroupPage=yes
DisableWelcomePage=no
OutputDir="."
OutputBaseFilename=Speckle
SetupIconFile=Assets\speckle.ico
Compression=lzma
SolidCompression=yes
WizardImageFile=Assets\installer.bmp
ChangesAssociations=yes
PrivilegesRequired=lowest
VersionInfoVersion={#AppVersion}

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Components]
Name: updater; Description: Speckle Updater - v{#AppVersion}; Types: full custom; Flags: fixed
Name: coregeometry; Description: Basic Geometry Object Model - v{#CoreGeometryVersion};  Types: full custom; Flags: fixed
Name: elements; Description: A Higher Level Object Model - v{#SpeckleElementsVersion};  Types: full custom; Flags: fixed  
Name: structural; Description: Structural Object Model - v{#SpeckleStructuralVersion};  Types: full custom; Flags: fixed
Name: dynamo; Description: Speckle for Dynamo 2.0 - v{#DynamoVersion}; Types: full
Name: dynamo2_1; Description: Speckle for Dynamo 2.1 - v{#DynamoVersion}; Types: full
Name: dynamo2_4; Description: Speckle for Dynamo 2.4 - v{#DynamoVersion}; Types: full  
Name: gh; Description: Speckle for Rhino 6 & Grasshopper - v{#RhinoVersion};  Types: full
Name: revit19; Description: Speckle for Revit 2019 ALPHA - v{#RevitVersion};  Types: full
Name: revit20; Description: Speckle for Revit 2020 ALPHA - v{#RevitVersion};  Types: full
Name: revit21; Description: Speckle for Revit 2021 ALPHA - v{#RevitVersion};  Types: full

;Name: excel; Description: Speckle for Revit;  Types: full

[Types]
Name: "full"; Description: "Full installation"
Name: "custom"; Description: "Custom installation"; Flags: iscustom

[Tasks]
Name: updates; Description: "Auto update, make sure I always have the best Speckle!";

[Dirs]
Name: "{app}"; Permissions: everyone-full 

[Files]
;updater
Source: "SpeckleUpdater\bin\Release\*"; DestDir: "{#SpeckleFolder}"; Flags: ignoreversion recursesubdirs;

;rhino+gh                                                                                                                                      
Source: "SpeckleRhino\*"; DestDir: "{userappdata}\McNeel\Rhinoceros\6.0\Plug-ins\Speckle Rhino Plugin (512d9705-6f92-49ca-a606-d6d5c1ac6aa2)\{#RhinoVersion}"; Flags: ignoreversion recursesubdirs; Components: gh  

;dynamo
Source: "SpeckleDynamo\*"; DestDir: "{userappdata}\Dynamo\Dynamo Revit\2.0\packages\Speckle for Dynamo\"; Flags: ignoreversion recursesubdirs; Components: dynamo
Source: "SpeckleDynamo\*"; DestDir: "{userappdata}\Dynamo\Dynamo Core\2.0\packages\Speckle for Dynamo\"; Flags: ignoreversion recursesubdirs; Components: dynamo

;dynamo2.1
Source: "SpeckleDynamo\*"; DestDir: "{userappdata}\Dynamo\Dynamo Revit\2.1\packages\Speckle for Dynamo\"; Flags: ignoreversion recursesubdirs; Components: dynamo2_1
Source: "SpeckleDynamo\*"; DestDir: "{userappdata}\Dynamo\Dynamo Core\2.1\packages\Speckle for Dynamo\"; Flags: ignoreversion recursesubdirs; Components: dynamo2_1

;dynamo for civil 3d
Source: "SpeckleDynamo\*"; DestDir: "{userappdata}\Autodesk\C3D 2020\Dynamo\2.0\packages\Speckle for Dynamo\"; Flags: ignoreversion recursesubdirs; Components: dynamo
Source: "SpeckleDynamo\*"; DestDir: "{userappdata}\Autodesk\C3D 2020\Dynamo\2.1\packages\Speckle for Dynamo\"; Flags: ignoreversion recursesubdirs; Components: dynamo2_1
Source: "SpeckleDynamo\*"; DestDir: "{userappdata}\Autodesk\C3D 2020\Dynamo\2.4\packages\Speckle for Dynamo\"; Flags: ignoreversion recursesubdirs; Components: dynamo2_4

;revit
Source: "SpeckleRevit2019\*"; DestDir: "{userappdata}\Autodesk\Revit\Addins\2019\"; Flags: ignoreversion recursesubdirs; Components: revit19
Source: "SpeckleRevit2020\*"; DestDir: "{userappdata}\Autodesk\Revit\Addins\2020\"; Flags: ignoreversion recursesubdirs; Components: revit20
Source: "SpeckleRevit2021\*"; DestDir: "{userappdata}\Autodesk\Revit\Addins\2021\"; Flags: ignoreversion recursesubdirs; Components: revit21


;excel                                                                                                                                    
;Source: "{#Repository}\Arup.Compute.Excel\bin\Release\Arup.Compute.Excel-AddIn-packed.xll"; DestDir: "{userappdata}\Microsoft\AddIns\"; Flags: ignoreversion; Components: excel  

;revit
;TODO

;tekla
;42

;coregeometry
Source: "SpeckleCoreGeometry\*"; DestDir: "{localappdata}\SpeckleKits\SpeckleCoreGeometry"; Flags: ignoreversion recursesubdirs; Components: coregeometry  

;elements
Source: "SpeckleElements\*"; DestDir: "{localappdata}\SpeckleKits\SpeckleElements"; Flags: ignoreversion recursesubdirs; Components: elements  

;structural
Source: "SpeckleStructural\*"; DestDir: "{localappdata}\SpeckleKits\SpeckleStructural"; Flags: ignoreversion recursesubdirs; Components: elements  

[InstallDelete]
Type: filesandordirs; Name: "{userappdata}\McNeel\Rhinoceros\6.0\Plug-ins\Speckle Rhino Plugin (512d9705-6f92-49ca-a606-d6d5c1ac6aa2)\*"
Type: filesandordirs; Name: "{cf}\McNeel\Rhinoceros\6.0\Plug-ins\Speckle Rhino Plugin (512d9705-6f92-49ca-a606-d6d5c1ac6aa2)\*"
Type: filesandordirs; Name: "{localappdata}\SpeckleKits\SpeckleCoreGeometry\*"        
Type: filesandordirs; Name: "{localappdata}\SpeckleKits\SpeckleElements\*"        
Type: filesandordirs; Name: "{localappdata}\SpeckleKits\SpeckleStructural\*"

[Registry]
Root: HKCU; Subkey: "SOFTWARE\McNeel\Rhinoceros\6.0\Plug-ins\512d9705-6f92-49ca-a606-d6d5c1ac6aa2"; ValueType: string; ValueName: "Name"; ValueData: "Speckle";
Root: HKCU; Subkey: "SOFTWARE\McNeel\Rhinoceros\6.0\Plug-ins\512d9705-6f92-49ca-a606-d6d5c1ac6aa2"; ValueType: string; ValueName: "FileName"; ValueData: "{userappdata}\McNeel\Rhinoceros\6.0\Plug-ins\Speckle Rhino Plugin (512d9705-6f92-49ca-a606-d6d5c1ac6aa2)\{#RhinoVersion}\SpeckleWinR6.rhp";  


[Icons]
Name: "{group}\Check for updates"; Filename: "{#SpeckleFolder}\{#UpdaterFilename}"; Parameters: "-showprogress"
Name: "{userappdata}\Microsoft\Windows\Start Menu\Programs\Startup\Speckle"; Filename: "{#SpeckleFolder}\{#UpdaterFilename}"; Tasks: updates
Name: "{group}\{cm:UninstallProgram,{#AppName}}"; Filename: "{uninstallexe}"
;Name: "{commondesktop}\{#AppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

;checks if minimun requirements are met
[Code]
function IsDotNetDetected(version: string; service: cardinal): boolean;
// Indicates whether the specified version and service pack of the .NET Framework is installed.
//
// version -- Specify one of these strings for the required .NET Framework version:
//    'v1.1.4322'     .NET Framework 1.1
//    'v2.0.50727'    .NET Framework 2.0
//    'v3.0'          .NET Framework 3.0
//    'v3.5'          .NET Framework 3.5
//    'v4\Client'     .NET Framework 4.0 Client Profile
//    'v4\Full'       .NET Framework 4.0 Full Installation
//    'v4.5'          .NET Framework 4.5
//
// service -- Specify any non-negative integer for the required service pack level:
//    0               No service packs required
//    1, 2, etc.      Service pack 1, 2, etc. required
var
    key: string;
    install, release, serviceCount: cardinal;
    check45, success: boolean;
begin
    // .NET 4.5 installs as update to .NET 4.0 Full
    if version = 'v4.5' then begin
        version := 'v4\Full';
        check45 := true;
    end else
        check45 := false;

    // installation key group for all .NET versions
    key := 'SOFTWARE\Microsoft\NET Framework Setup\NDP\' + version;

    // .NET 3.0 uses value InstallSuccess in subkey Setup
    if Pos('v3.0', version) = 1 then begin
        success := RegQueryDWordValue(HKLM, key + '\Setup', 'InstallSuccess', install);
    end else begin
        success := RegQueryDWordValue(HKLM, key, 'Install', install);
    end;

    // .NET 4.0/4.5 uses value Servicing instead of SP
    if Pos('v4', version) = 1 then begin
        success := success and RegQueryDWordValue(HKLM, key, 'Servicing', serviceCount);
    end else begin
        success := success and RegQueryDWordValue(HKLM, key, 'SP', serviceCount);
    end;

    // .NET 4.5 uses additional value Release
    if check45 then begin
        success := success and RegQueryDWordValue(HKLM, key, 'Release', release);
        success := success and (release >= 378389);
    end;

    result := success and (install = 1) and (serviceCount >= service);
end;

//Revit 2017/18 need 4.6, should update?
function InitializeSetup(): Boolean;
var
  ErrCode: integer;
begin
    if not IsDotNetDetected('v4.5', 0) then begin
      if  MsgBox('{#AppName} requires Microsoft .NET Framework 4.5.'#13#13
            'Do you want me to open http://www.microsoft.com/net'#13
            'so you can download it?',  mbConfirmation, MB_YESNO) = IDYES
            then begin
              ShellExec('open', 'http://www.microsoft.com/net',
                '', '', SW_SHOW, ewNoWait, ErrCode);
      end;
  
         result := false;
    end else
        result := true;
end;