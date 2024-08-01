function Set-TabFromJson {
    [CmdletBinding()]
    param (
		  [Parameter(Mandatory=$true)] $JsonFile,
      [Parameter(Mandatory=$true)] $TabControl,
      [Parameter(Mandatory=$true)] $FormElements
    )

    #Get JSON, load tabconbtrol as form
    $configText = (Get-Content -Path $JsonFile -Raw)
    $config = $configText | ConvertFrom-Json | ConvertTo-HashtableV5
    $tab = $config.tab

    $Tab1 = New-object System.Windows.Forms.Tabpage
    $Tab1.DataBindings.DefaultDataSourceUpdateMode = 0
    $Tab1.UseVisualStyleBackColor = $True
    $Tab1.Name = $tab.Name
    $Tab1.Text = $tab.Text
    $FormElements.Add($tab.Name, @{})
    Set-ElementsFromJson -Form $Tab1 -FormHash $FormElements[$tab.Name] -Elements $config.Elements    
    $TabControl.Controls.Add($Tab1)
    
}
Export-ModuleMember -Function Set-TabFromJson