function New-ComplexForm {
    [CmdletBinding()]
    param ()
    # ===== TOP ===== 
    $FormJson =  $PSCommandPath.Replace(".ps1",".json")
    $NewForm, $FormElements = Set-FormFromJson $FormJson

    # ===== Single Tab =====
    $FormElements.button_ComplexCheckName.Add_Click({
      $Name = $FormElements.textBox_ComplexName.text = ($FormElements.textBox_ComplexName.text).trim()
      $Age,$Count = Get-AgeBasedOnName $Name
      $NewObj = [PSCustomObject]@{
        Name    = $Name
        Age     = $Age
        Count   = $Count
      }
      $Global:NamesList += $NewObj
      Set-ListViewElementsFromData -ListView $FormElements.list_ComplexNames -Data $Global:NamesList
      $FormElements.textBox_ComplexName.text = ""
    })

    $FormElements.button_ComplexRemoveLine.Add_Click({
      $SelectedI = $FormElements.list_ComplexNames.SelectedIndices
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
        Set-ListViewElementsFromData -ListView $FormElements.list_ComplexNames -Data $Global:NamesList
      }
    })    
    #
    $Global:NamesList = @()

    # ===== BOTTOM ===== 
    $NewForm.ShowDialog()
}
Export-ModuleMember -Function New-ComplexForm