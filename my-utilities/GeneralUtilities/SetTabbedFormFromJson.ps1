function Set-TabbedFormFromJson {
    [CmdletBinding()]
    param (
		  [Parameter(Mandatory=$true)] $JsonFile
    )

    $FormElements = @{}
    $configText = (Get-Content -Path $JsonFile -Raw)
    $config = $configText | ConvertFrom-Json | ConvertTo-HashtableV5
    if ($config.tab){
      $form = $config.tab
    } else {
      $form = $config.form
    }


    #Main Window
    $main_form = New-Object System.Windows.Forms.Form
    $main_form.Text = $form.Text
    $main_form.Width = $form.Width
    $main_form.Height = $form.Height
    $main_form.AutoSize = $true
    
    Set-ElementsFromJson -Form $main_form -FormHash $FormElements -Elements $config.Elements

    if ($form.TabControl){
      $TabControl = New-object System.Windows.Forms.TabControl
      $TabControl.Size = "$($config.Form.TabControl.Width),$($config.Form.TabControl.Height)"
      $TabControl.Location = $config.Form.TabControl.location
  
      $main_form.Controls.Add($TabControl)
    }


    return $main_form, $FormElements, $TabControl
}
Export-ModuleMember -Function Set-TabbedFormFromJson