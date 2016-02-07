
## git-powershell-silent-install

Silently install Git and SourceTree using PowerShell.

To use, ensure the following files are in the same folder as these scripts.

* Git-2.7.0.2-64-bit.exe
* SourceTreeSetup_1.7.0.32509.exe
* sourcetree.license

The versions to install are at the top of the script files if you want to change them.

### To use
Right-click on the `sourcetree-silent-install.ps1` and select `Run with PowerShell`.
A UAC prompt to elevate priviledges will come up, select `Yes`.

### Notes
* Must have admin rights to install.
* The SourceTree install script will install Git if not already installed. It will not check if Git is at the desired version however.  If you want to upgrade Git, use the `git-silent-install.ps1` file in a similar fashion.

