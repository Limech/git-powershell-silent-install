

## Install Git if not already installed
$gitInstalledPath = 'C:\Program Files\Git\bin\git.exe'
$gitInstallScript = Resolve-Path ".\git-silent-install.ps1"

if (!(Test-Path $gitInstalledPath))
{
   if (Test-Path $gitInstallScript)
   {
       &"$gitInstallScript"
   }
   
}


### Uninstall previous installation
$app = Get-WmiObject -Class Win32_Product | Where-Object {$_.Name -match "SourceTree"}
if ($app)
{
   $app.Uninstall()
}

## Installation and configuration variables
$appFolderDest =  "C:\Program Files (x86)\Atlassian\SourceTree\"

### Install new application
$appInstaller = Resolve-Path ".\SourceTreeSetup_1.7.0.32509.exe"
$commandLineOptions = "/qb"
Start-Process -Wait -FilePath $appInstaller -ArgumentList $commandLineOptions


### Copy configuration file
$configFileSrc = Resolve-Path  ".\SourceTree.exe.config"
$configFileDest = $appFolderDest
Copy-Item $configFileSrc -Destination (New-Item $configFileDest -Type container -Force) -Force

### Copy license file
$licenseFileSrc = Resolve-Path ".\sourcetree.license"
$licenseFileDest = $env:LOCALAPPDATA + "\Atlassian\SourceTree\"
Copy-Item $file -Destination (New-Item $licenseDestPath -Type container -Force) -Force





