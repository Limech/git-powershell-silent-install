
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
