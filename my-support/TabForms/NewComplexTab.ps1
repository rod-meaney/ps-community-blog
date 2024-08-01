function New-ComplexTab {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory=$true)] $FormElements
  )

    $FormElements.ComplexTab.button_CheckName.Add_Click({
      $Name = $FormElements.ComplexTab.textBox_Name.text = ($FormElements.ComplexTab.textBox_Name.text).trim()
      $Age,$Count = Get-AgeBasedOnName $Name
      $NewObj = [PSCustomObject]@{
        Name    = $Name
        Age     = $Age
        Count   = $Count
      }
      $Global:NamesList += $NewObj
      Set-ListViewElementsFromData -ListView $FormElements.ComplexTab.list_Names -Data $Global:NamesList
      $FormElements.ComplexTab.textBox_Name.text = ""
    })

    $FormElements.ComplexTab.button_RemoveLine.Add_Click({
      $SelectedI = $FormElements.ComplexTab.list_Names.SelectedIndices
      if($SelectedI.count -ne 1){
        throw "You must select 1 line only when removing"
      } else {
        $NewNameList = @()
        for ([int]$i = 0 ; $i -lt $Global:NamesList.Count ; $i++){
          if ($SelectedI[0] -ne $i) {
            $NewNameList += $Global:NamesList[$i]
          }
        }
        $Global:NamesList = $NewNameList
        Set-ListViewElementsFromData -ListView $FormElements.ComplexTab.list_Names -Data $Global:NamesList
      }
    })    
    #
    $Global:NamesList = @()

  }
Export-ModuleMember -Function New-ComplexTab