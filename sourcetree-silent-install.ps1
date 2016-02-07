Param([string]$versionToInstall="1.7.0.32509")

Write-Host "Installing SourceTree version" $versionToInstall

## Install Git if not already installed
$gitInstalledPath = 'C:\Program Files\Git\bin\git.exe'
$gitInstallScript = Resolve-Path ".\git-silent-install.ps1"

### Only install if Git folder isn't there.
if (!(Test-Path $gitInstalledPath))
{
   ### If the git install script exists, call it.
   if (Test-Path $gitInstallScript)
   {
       &"$gitInstallScript"
   }
   
}

### Uninstall previous installation of SourceTree
$sourceTreeInstallations = Get-WmiObject -Class Win32_Product | Where-Object {$_.Name -match "SourceTree"}
$thisVersionAlreadyInstalled = $false

foreach ($sourceTreeInstallation in $sourceTreeInstallations) 
{
   Write-Host "Found version" $sourceTreeInstallation.Version

   if ($sourceTreeInstallation.Version -ne $versionToInstall)
   {
      if ($app)
      {
         Write-Host "Uninstalling SourceTree version " $app.Version
         $app.Uninstall()
      }
   }
   else
   {
      $thisVersionAlreadyInstalled = $true
   }   
}

if (!($thisVersionAlreadyInstalled))
{
   ## Installation and configuration variables
   $appFolderDest =  "C:\Program Files (x86)\Atlassian\SourceTree\"

   ### Install new application
   $appInstallerFilename = ".\SourceTreeSetup_" + $versionToInstall + ".exe"
   $appInstaller = Resolve-Path $appInstallerFilename
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
}
else
{
   Write-Host "SourceTree" $versionToInstall " is already installed."
}





