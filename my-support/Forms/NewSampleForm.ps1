function New-SampleForm {
    [CmdletBinding()]
    param ()
    # ===== TOP ===== 
    $FormJson =  $PSCommandPath.Replace(".ps1",".json")
    $NewForm, $FormElements = Set-FormFromJson $FormJson

    # ===== Single Tab =====
    $FormElements.button_SampleTram.Add_Click({
      $TramStop = ($FormElements.combo_SampleTrams.SelectedItem).split("|")[0].trim()
      $Route = ($FormElements.combo_SampleTrams.SelectedItem).split(" ")[3].trim()
      Write-Host "Next 3 trams for stop $TramStop, route $Route"
      Get-Next3TramsMinutes $TramStop $Route | ForEach-Object{
        Write-Host "$_ minutes"
      }
    })

    $FormElements.button_SampleNextTram.Add_Click({
      $TramStop = ($FormElements.combo_SampleTrams.SelectedItem).split("|")[0].trim()
      $Route = ($FormElements.combo_SampleTrams.SelectedItem).split(" ")[3].trim()
      Write-Host "Next trams for stop $TramStop, route $Route is $(Get-MyNextTramArrival $TramStop $Route) minutes"
    })

    $FormElements.button_SampleRandomCatFacts.Add_Click({
      Write-Host "$(Get-RandomCatFact)"
    })

    $FormElements.button_SampleNameAge.Add_Click({
      $Name = $FormElements.textBox_SampleNameAge.text = ($FormElements.textBox_SampleNameAge.text).trim()
      $Age,$Count = Get-AgeBasedOnName $Name
      Write-Host "$Name average age is $Age. Based on $Count instances of the name"
    })

    # ===== BOTTOM ===== 
    $NewForm.ShowDialog()
}
Export-ModuleMember -Function New-SampleForm