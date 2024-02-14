#Switching between 2 profiles in P7 and P5
function Switch-Profiles {
    [CmdletBinding()]
    param ()
    
    $P7DocumentDir = "$([Environment]::GetFolderPath("MyDocuments"))\PowerShell"
    $P5DocumentDir = "$([Environment]::GetFolderPath("MyDocuments"))\WindowsPowerShell"
    $ProfileName = "Profile.ps1"
    $ProfileWorkName = "ProfileWork.ps1"
    $ProfileHomeName = "ProfileHome.ps1"

    #Fix Powrsehll 7
    If (Test-Path "$P7DocumentDir\$ProfileWorkName"){
        #Currently Using Home dir
        Write-Host "Changing P7 to WORK"
        Rename-Item "$P7DocumentDir\$ProfileName" "$P7DocumentDir\$ProfileHomeName"
        Rename-Item "$P7DocumentDir\$ProfileWorkName" "$P7DocumentDir\$ProfileName"
    } else {
        #Currently Using Home dir
        Write-Host "Changing P7 to HOME"
        Rename-Item "$P7DocumentDir\$ProfileName" "$P7DocumentDir\$ProfileWorkName"
        Rename-Item "$P7DocumentDir\$ProfileHomeName" "$P7DocumentDir\$ProfileName"
    }
    
    #Fix Powrsehll 5
    If (Test-Path "$P5DocumentDir\$ProfileWorkName"){
        #Currently Using Home dir
        Write-Host "Changing P5 to WORK"
        Rename-Item "$P5DocumentDir\$ProfileName" "$P5DocumentDir\$ProfileHomeName" -Force
        Rename-Item "$P5DocumentDir\$ProfileWorkName" "$P5DocumentDir\$ProfileName" -Force
    } else {
        #Currently Using Work dir
        Write-Host "Changing P5 to HOME"
        Rename-Item "$P5DocumentDir\$ProfileName" "$P5DocumentDir\$ProfileWorkName"
        Rename-Item "$P5DocumentDir\$ProfileHomeName" "$P5DocumentDir\$ProfileName"
    }

}

Export-ModuleMember -Function Switch-Profiles