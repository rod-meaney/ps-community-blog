function New-TabbedForm {
    [CmdletBinding()]
    param ()
    # ===== TOP ===== 
    $FormJson =  $PSCommandPath.Replace(".ps1",".json")
    $NewForm, $FormElements = Set-FormFromJson $FormJson

    # ===== Tab Sample START =====
    $FormElements.tab_Sample.button_SampleTram.Add_Click({
      $TramStop = ($FormElements.tab_Sample.combo_SampleTrams.SelectedItem).split("|")[0].trim()
      $Route = ($FormElements.tab_Sample.combo_SampleTrams.SelectedItem).split(" ")[3].trim()
      Write-Host "Next 3 trams for stop $TramStop, route $Route"
      Get-Next3TramsMinutes $TramStop $Route | ForEach-Object{
        Write-Host "$_ minutes"
      }
    })

    $FormElements.tab_Sample.button_SampleNextTram.Add_Click({
      $TramStop = ($FormElements.tab_Sample.combo_SampleTrams.SelectedItem).split("|")[0].trim()
      $Route = ($FormElements.tab_Sample.combo_SampleTrams.SelectedItem).split(" ")[3].trim()
      Write-Host "Next trams for stop $TramStop, route $Route is $(Get-MyNextTramArrival $TramStop $Route) minutes"
    })

    $FormElements.tab_Sample.button_SampleRandomCatFacts.Add_Click({
      Write-Host "$(Get-RandomCatFact)"
    })

    $FormElements.tab_Sample.button_SampleNameAge.Add_Click({
      $Name = $FormElements.tab_Sample.textBox_SampleNameAge.text = ($FormElements.tab_Sample.textBox_SampleNameAge.text).trim()
      $Age,$Count = Get-AgeBasedOnName $Name
      Write-Host "$Name average age is $Age. Based on $Count instances of the name"
    })
    # ===== Tab Sample END =====

    # ===== Tab Game START =====
    $FormElements.tab_Game.button_GameGuess.Add_Click({
      $Guess = $FormElements.tab_Game.combo_GameNumber.SelectedItem
      $Roll = 1,2,3,4,5 | Get-Random
      $result = "You LOSE."
      if ($Roll -eq [int]$Guess){$result = "You WIN."}
      Write-Host "$result You guessed $Guess, machine guessed $Roll"
    })
    # ===== Tab Game END =====

    # ===== Tab Complex START =====
    $FormElements.tab_Complex.button_ComplexCheckName.Add_Click({
      $Name = $FormElements.tab_Complex.textBox_ComplexName.text = ($FormElements.tab_Complex.textBox_ComplexName.text).trim()
      $Age,$Count = Get-AgeBasedOnName $Name
      $NewObj = [PSCustomObject]@{
        Name    = $Name
        Age     = $Age
        Count   = $Count
      }
      $Global:NamesList += $NewObj
      Set-ListViewElementsFromData -ListView $FormElements.tab_Complex.list_ComplexNames -Data $Global:NamesList
      $FormElements.tab_Complex.textBox_ComplexName.text = ""
    })

    $FormElements.tab_Complex.button_ComplexRemoveLine.Add_Click({
      $SelectedI = $FormElements.tab_Complex.list_ComplexNames.SelectedIndices
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
        Set-ListViewElementsFromData -ListView $FormElements.tab_Complex.list_ComplexNames -Data $Global:NamesList
      }
    })    
    #
    $Global:NamesList = @()
    # ===== Tab Complex END =====

    # ===== BOTTOM ===== 
    $NewForm.ShowDialog()
}
Export-ModuleMember -Function New-TabbedForm