function New-AddRemoveTabForm {
  [CmdletBinding()]
  param ()
  # ===== TOP ===== 
  $FormJson =  $PSCommandPath.Replace(".ps1",".json")
  $NewForm, $ParentElements, $TabControl = Set-TabbedFormFromJson $FormJson

  # ===== LOAD TABS ===== 

  $FPath = Split-Path -Parent $PSCommandPath
  
  # ===== FORM EVENTS ===== 
  $Global:FormElements = @{}
  $TabControl.Controls.clear()
  $ParentElements.button_add_complex.Add_Click({
    Set-TabFromJson -JsonFile "$FPath\NewComplexTab.json" -TabControl $TabControl -FormElements $FormElements
    New-ComplexTab -FormElements $FormElements
  })

  $ParentElements.button_add_sample.Add_Click({
    Set-TabFromJson -JsonFile "$FPath\NewSampleTab.json" -TabControl $TabControl -FormElements $FormElements
    New-SampleTab -FormElements $FormElements
  })

  $ParentElements.button_clear.Add_Click({
    $TabControl.Controls.Clear()
    $Global:FormElements = @{}
  })

  # ===== BOTTOM ===== 
  $NewForm.ShowDialog()

}
Export-ModuleMember -Function New-AddRemoveTabForm