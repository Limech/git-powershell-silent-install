Param([string]$versionToInstall="1.7.0.32509")
#Param([string]$versionToInstall="1.6.25")

If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{   
  $arguments = "& '" + $myinvocation.mycommand.definition + "'"
  Start-Process "$psHome\powershell.exe" -Verb runAs -ArgumentList $arguments
  break
}

Set-Location $PSScriptRoot

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
Write-Host "Looking to see if SourceTree is already installed..."
$sourceTreeInstallations = Get-WmiObject -Class Win32_Product | Where-Object {$_.Name -match "SourceTree"}

if ($sourceTreeInstallations)
{
  foreach ($sourceTreeInstallation in $sourceTreeInstallations) 
  {
     Write-Host "Found version" $sourceTreeInstallation.Version

     if ($sourceTreeInstallation.Version -ne $versionToInstall)
     {
         ## Kill SourceTree if it's running
         Stop-Process -processname SourceTree -erroraction 'silentlycontinue'

         ## Install SourceTree
         Write-Host "Uninstalling SourceTree version " $sourceTreeInstallation.Version
         if ($sourceTreeInstallation.uninstall().returnvalue -eq 0) { write-host "Successfully uninstalled SourceTree" }
         else { write-warning "Failed to uninstall SourceTree" }

      }
      else
      {
         Write-Host "SourceTree" $versionToInstall " is already installed."
         return
      }   
   }
}
else
{ 
    Write-Host "No SourceTree installation found"
}


## Installation and configuration variables
$appFolderDest =  "C:\Program Files (x86)\Atlassian\SourceTree\"

### Install new application
$appInstallerFilename = ".\SourceTreeSetup_" + $versionToInstall + ".exe"
$appInstaller = Resolve-Path $appInstallerFilename
$logFile = $env:TEMP + "\SourceTree-install-" + $timestamp + ".log"
$commandLineOptions = "/qn /L*V `"$logFile`""
Write-Host "Installing SourceTree version:" $versionToInstall
Write-Host "with:" $appInstaller $commandLineOptions
Start-Process -Wait -FilePath $appInstaller -ArgumentList $commandLineOptions

### Copy configuration file
$configFileSrc = Resolve-Path  ".\SourceTree.exe.config"
$configFileDest = $appFolderDest
Copy-Item $configFileSrc -Destination (New-Item $configFileDest -Type container -Force) -Force

### Copy license file
$licenseFileSrc = Resolve-Path ".\sourcetree.license"
$licenseFileDest = $env:LOCALAPPDATA + "\Atlassian\SourceTree\"
Copy-Item $file -Destination (New-Item $licenseDestPath -Type container -Force) -Force

Write-Host "SourceTree" $versionToInstall " has been installed."