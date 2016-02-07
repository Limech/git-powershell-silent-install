If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{   
  $arguments = "& '" + $myinvocation.mycommand.definition + "'"
  Start-Process "$psHome\powershell.exe" -Verb runAs -ArgumentList $arguments
  break
}

Set-Location $PSScriptRoot

## There can be many places where git could have been installed.  Check likely places.
### List of likely places where Git could be 
$possibleInstalledPaths = @("C:\Program Files\Git\", "C:\Program Files (x64)\Git\", "c:\git\")

$foundAnInstallation = $false
### For all places where Git "could" be.
foreach ($installPath in $possibleInstalledPaths)
{
    
    ### If the path where Git could be exists
    if (Test-Path($installPath))
    {

        ## Some Git stuff might be running.. kill them.
        Stop-Process -processname Bash -erroraction 'silentlycontinue'
        Stop-Process -processname Putty* -erroraction 'silentlycontinue'

        $foundAnInstallation = $true
        Write-Host "Removing Git from " $installPath

        ### Find if there's an uninstaller in the folder.
        $uninstallers = Get-ChildItem $installPath"\unins*.exe"

        ### In reality, there should only be just one that matches.
        foreach ($uninstaller in $uninstallers)
        {
           ### Invoke the uninstaller.
           $uninstallerCommandLineOptions = "/SP- /VERYSILENT /SUPPRESSMSGBOXES /FORCECLOSEAPPLICATIONS"
           Start-Process -Wait -FilePath $uninstaller -ArgumentList $uninstallerCommandLineOptions
        }

        ### Remove the folder if it didn't clean up properly.
        if (Test-Path($installPath))
        {
           Remove-Item -Recurse -Force $installPath
        }
    }
}

if (!($foundAnInstallation))
{
   Write-Host "No git installation found. Nothing to uninstall"
}
