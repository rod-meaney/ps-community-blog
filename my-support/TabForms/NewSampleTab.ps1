function New-SampleTab {
    [CmdletBinding()]
    param (
      [Parameter(Mandatory=$true)] $FormElements
    )

    $FormElements.SampleTab.button_Tram.Add_Click({
      $TramStop = ($FormElements.SampleTab.combo_Trams.SelectedItem).split("|")[0].trim()
      $Route = ($FormElements.SampleTab.combo_Trams.SelectedItem).split(" ")[3].trim()
      Write-Host "Next 3 trams for stop $TramStop, route $Route"
      Get-Next3TramsMinutes $TramStop $Route | ForEach-Object{
        Write-Host "$_ minutes"
      }
    })

    $FormElements.SampleTab.button_NextTram.Add_Click({
      $TramStop = ($FormElements.SampleTab.combo_Trams.SelectedItem).split("|")[0].trim()
      $Route = ($FormElements.SampleTab.combo_Trams.SelectedItem).split(" ")[3].trim()
      Write-Host "Next trams for stop $TramStop, route $Route is $(Get-MyNextTramArrival $TramStop $Route) minutes"
    })

    $FormElements.SampleTab.button_RandomCatFacts.Add_Click({
      Write-Host "$(Get-RandomCatFact)"
    })

    $FormElements.SampleTab.button_NameAge.Add_Click({
      $Name = $FormElements.SampleTab.textBox_NameAge.text = ($FormElements.SampleTab.textBox_NameAge.text).trim()
      $Age,$Count = Get-AgeBasedOnName $Name
      Write-Host "$Name average age is $Age. Based on $Count instances of the name"
    })

}
Export-ModuleMember -Function New-SampleTab