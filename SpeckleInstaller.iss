;defining variables
#define AppName      "Speckle"
#define AppVersion GetFileVersion("SpeckleUpdater\bin\Release\SpeckleUpdater.exe")
#define RhinoVersion  GetFileVersion("SpeckleRhino\Release\SpeckleRhinoConverter.dll")
#define DynamoVersion  GetFileVersion("SpeckleDynamo\SpeckleDynamo\bin\Release\SpeckleDynamo.dll")
#define AppPublisher "Speckle"
#define AppURL       "https://speckle.works"

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
DefaultDirName={localappdata}\Speckle
DisableDirPage=yes
DefaultGroupName={#AppName}
DisableProgramGroupPage=yes
DisableWelcomePage=no
OutputDir="."
OutputBaseFilename=Speckle
;SetupIconFile={#Repository}\Assets\icon.ico
Compression=lzma
SolidCompression=yes
;WizardImageFile={#Repository}\Assets\bcfier-banner.bmp
ChangesAssociations=yes
PrivilegesRequired=lowest

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Components]
Name: dynamo; Description: Speckle for Dynamo 2.0 v{#DynamoVersion}; Types: full 
Name: gh; Description: Speckle for Rhino+Grasshopper v{#RhinoVersion};  Types: full
;Name: excel; Description: Speckle for Revit;  Types: full


[Dirs]
Name: "{app}"; Permissions: everyone-full 

[Files]
;updater
Source: "SpeckleUpdater\bin\Release\*"; DestDir: "{userappdata}\Speckle\"; Flags: ignoreversion recursesubdirs;

;dynamo
Source: "SpeckleDynamo\SpeckleDynamo\bin\Release\Speckle for Dynamo\*"; DestDir: "{userappdata}\Dynamo\Dynamo Revit\2.0\packages\Speckle for Dynamo\"; Flags: ignoreversion recursesubdirs; Components: dynamo
Source: "SpeckleDynamo\SpeckleDynamo\bin\Release\Speckle for Dynamo\*"; DestDir: "{userappdata}\Dynamo\Dynamo Core\2.0\packages\Speckle for Dynamo\"; Flags: ignoreversion recursesubdirs; Components: dynamo

;rhino+gh                                                                                                                                      
Source: "SpeckleRhino\Release\*"; DestDir: "{userappdata}\McNeel\Rhinoceros\6.0\Plug-ins\Speckle Rhino Plugin (512d9705-6f92-49ca-a606-d6d5c1ac6aa2)\{#RhinoVersion}"; Flags: ignoreversion recursesubdirs; Components: gh  

;excel                                                                                                                                    
;Source: "{#Repository}\Arup.Compute.Excel\bin\Release\Arup.Compute.Excel-AddIn-packed.xll"; DestDir: "{userappdata}\Microsoft\AddIns\"; Flags: ignoreversion; Components: excel   


[Icons]
Name: "{group}\Check for updates"; Filename: "{app}\{#UpdaterFilename}"
Name: "{userappdata}\Microsoft\Windows\Start Menu\Programs\Startup\Speckle"; Filename: "{app}\{#UpdaterFilename}"
Name: "{group}\{cm:UninstallProgram,{#AppName}}"; Filename: "{uninstallexe}"
;Name: "{commondesktop}\{#AppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

;[Registry]
;Root: HKCU; Subkey: "SOFTWARE\Microsoft\Office\16.0\Excel\Options"; ValueType: string; ValueName: "OPEN"; ValueData: "/R ""Arup.Compute.Excel-AddIn-packed.xll""";

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