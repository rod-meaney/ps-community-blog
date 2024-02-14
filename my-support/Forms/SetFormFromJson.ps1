function Set-FormFromJson {
    [CmdletBinding()]
    param (
		[Parameter(Mandatory=$true)] $JsonFile
    )

    $FormElements = @{}
    $configText = (Get-Content -Path $JsonFile -Raw)
    $config = $configText | ConvertFrom-Json | ConvertTo-HashtableV5
    
    #Main Window
    $main_form = New-Object System.Windows.Forms.Form
    $main_form.Text = $config.Form.Text
    $main_form.Width = $config.Form.Width
    $main_form.Height = $config.Form.Height
    $main_form.AutoSize = $true
    
    if ($config.ContainsKey("Tabs")){ 
        $FormTabControl = New-object System.Windows.Forms.TabControl
        $FormTabControl.Size = "$($config.Form.Width),$($config.Form.Height)"
        $FormTabControl.Location = "0,0"
        
        $main_form.Controls.Add($FormTabControl)
        foreach ($tab in $config.Tabs){
            $Tab1 = New-object System.Windows.Forms.Tabpage
            $Tab1.DataBindings.DefaultDataSourceUpdateMode = 0
            $Tab1.UseVisualStyleBackColor = $True
            $Tab1.Name = $tab.Name
            $Tab1.Text = $tab.Text
            $FormElements.Add($tab.Name, @{})
            Set-FormElementsFromJson -FormOrTab $Tab1 -FormOrTabHash $FormElements[$tab.Name] -Elements $tab.Elements    
            $FormTabControl.Controls.Add($Tab1)
        }
    } else {
        Set-FormElementsFromJson -FormOrTab $main_form -FormOrTabHash $FormElements -Elements $config.Elements
    }
    return $main_form, $FormElements
}
Export-ModuleMember -Function Set-FormFromJson