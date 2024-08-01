function New-SampleTabForm {
  [CmdletBinding()]
  param ()
  # ===== TOP ===== 
  $FormJson =  $PSCommandPath.Replace(".ps1",".json")
  $NewForm, $FormElements, $TabControl = Set-TabbedFormFromJson $FormJson

  # ===== LOAD TABS ===== 
  $FPath = Split-Path -Parent $PSCommandPath
  Set-TabFromJson -JsonFile "$FPath\NewSampleTab.json" -TabControl $TabControl -FormElements $FormElements
  New-SampleTab -FormElements $FormElements
  
  # ===== FORM EVENTS ===== 

  # ===== BOTTOM ===== 
  $NewForm.ShowDialog()

}
Export-ModuleMember -Function New-SampleTabForm