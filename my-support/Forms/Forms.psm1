Get-ChildItem -Path "$PSScriptRoot\*.ps1" | ForEach-Object{. $PSScriptRoot\$($_.Name)}
Add-Type -assembly System.Windows.Forms
Add-Type -AssemblyName System.Drawing