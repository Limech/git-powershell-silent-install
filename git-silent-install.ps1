
$timestamp = Get-Date -format yyMMdd-HHmmss
$installer = "C:\dev\github\limech\git-powershell-silent-install\Git-2.7.0.2-64-bit.exe"
$commandLineOptions = "/SP- /VERYSILENT /SUPPRESSMSGBOXES /FORCECLOSEAPPLICATIONS /LOADINF='install-defaults.txt'"

$uninstaller ="C:\Program Files (x86)\Git\unins000.exe"
$uninstallerCommandLineOptions = "/SP- /VERYSILENT /SUPPRESSMSGBOXES /FORCECLOSEAPPLICATIONS"

if (Test-Path $uninstaller)
{
    Start-Process -Wait -FilePath $uninstaller -ArgumentList $uninstallerCommandLineOptions
}

$uninstaller ="C:\Program Files\Git\unins000.exe"

if (Test-Path $uninstaller)
{
    Start-Process -Wait -FilePath $uninstaller -ArgumentList $uninstallerCommandLineOptions
}

Start-Process -Wait -FilePath $installer -ArgumentList $commandLineOptions


## Configure git with some defaults
### Set git as a command alias
if (!(Test-Path -Path "alias:git")) 
{
   new-item -path alias:git -value 'C:\Program Files\Git\bin\git.exe'
}
### Invoke git commands that set defaults for user.
git config --global credential.helper wincred
git config --global push.default simple
git config --global core.autocrlf true