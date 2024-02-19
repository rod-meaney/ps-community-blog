function Set-FormElementsFromJson {
    [CmdletBinding()]
    param (
		[Parameter(Mandatory=$true)] $FormOrTab,
        [Parameter(Mandatory=$true)] $FormOrTabHash,
        [Parameter(Mandatory=$true)] $Elements
    )
    $FontSize = 9
    foreach($el in $Elements){
        $FontStyle = [System.Drawing.Font]::new("Microsoft Sans Serif", $FontSize, [System.Drawing.FontStyle]::Regular)
        if ($el.FontStyle) {
            Switch (($el.FontStyle).ToUpper()) {
                "BOLD" {$FontStyle = [System.Drawing.Font]::new("Microsoft Sans Serif", $FontSize, [System.Drawing.FontStyle]::Bold)}
                "ITALIC" {$FontStyle = [System.Drawing.Font]::new("Microsoft Sans Serif", $FontSize, [System.Drawing.FontStyle]::Italic)}
                "STRIKEOUT" {$FontStyle = [System.Drawing.Font]::new("Microsoft Sans Serif", $FontSize, [System.Drawing.FontStyle]::Strikeout)}
                "UNDERLINE" {$FontStyle = [System.Drawing.Font]::new("Microsoft Sans Serif", $FontSize, [System.Drawing.FontStyle]::Underline)}
                Default {$FontStyle = [System.Drawing.Font]::new("Microsoft Sans Serif", $FontSize, [System.Drawing.FontStyle]::Regular)}
            }
        }
        switch ($el.Type) {
            "Label" {
                $Label              = New-Object System.Windows.Forms.Label
                $Label.Text         = $el.Text
                $Label.Location     = New-Object System.Drawing.Point($el.x,$el.y)
                $Label.AutoSize     = $true
                $Label.Font         = $FontStyle
                $FormOrTabHash.Add($el.Name, $Label)
                $FormOrTab.Controls.Add($Label)
            }
            "LinkLabel" {
                #Note, you need to do Add-Click with the URL in the Form iteself
                $LinkLabel                  = New-Object System.Windows.Forms.LinkLabel
                $LinkLabel.Text             = $el.Text
                $LinkLabel.Location         = New-Object System.Drawing.Point($el.x,$el.y)
                $LinkLabel.AutoSize         = $true
                $LinkLabel.Font             = $FontStyle
                $LinkLabel.LinkColor        = "BLUE"
                $LinkLabel.ActiveLinkColor  = "RED"
                $FormOrTabHash.Add($el.Name, $LinkLabel)
                $FormOrTab.Controls.Add($LinkLabel)
            }            
            "ComboBox" {
                $ComboBox           = New-Object System.Windows.Forms.ComboBox
                $ComboBox.Width     = $el.Width
                $ComboBox.Location  = New-Object System.Drawing.Point($el.x,$el.y)
                if($el.Monospace){
                    $ComboBox.Font  = New-Object System.Drawing.Font("Courier New",$FontSize,[System.Drawing.FontStyle]::Regular)}
                else {
                    $ComboBox.Font  = $FontStyle
                } 
                #Items is optional, add lookup in ~Form.ps1
                if($el.Items) {$el.Items | ForEach-Object {[void] $ComboBox.Items.Add($_)}}
                if($el.SelectedIndex){$ComboBox.SelectedIndex = [int]$el.SelectedIndex}
                $FormOrTabHash.Add($el.Name, $ComboBox)
                $FormOrTab.Controls.Add($ComboBox)
            }
            "Button" {
                $Button             = New-Object System.Windows.Forms.Button
                $Button.Text        = $el.Text
                $Button.Location    = New-Object System.Drawing.Size($el.x,$el.y)
                $Button.Size        = New-Object System.Drawing.Size($el['Size-x'],$el['Size-y'])
                $Button.Font        = $FontStyle
                $FormOrTabHash.Add($el.Name, $Button)
                $FormOrTab.Controls.Add($Button)
            }
            "ListView" {
                #https://info.sapien.com/index.php/guis/gui-controls/spotlight-on-the-listview-control
                #https://www.sapien.com/blog/2012/04/04/spotlight-on-the-listview-control-part-1/
                #https://www.sapien.com/blog/2012/04/05/spotlight-on-the-listview-control-part-2/
                $ListView            = New-Object System.Windows.Forms.ListView
                $ListView.Location   = New-Object System.Drawing.Point($el.x,$el.y)
                $ListView.Width      = $el.Width
                $ListView.Height     = $el.Height  
                $ListView.GridLines  = $true
                $ListView.View       = [System.Windows.Forms.View]::Details
                $ListView.FullRowSelect = $true

                $ListView.Columns.Add($el.Item, -2, [System.Windows.Forms.HorizontalAlignment]::Left) | Out-Null
                foreach($col in $el.SubItems){
                  $ListView.Columns.Add($col, -2, [System.Windows.Forms.HorizontalAlignment]::Left) | Out-Null
                }

                $FormOrTabHash.Add($el.Name, $ListView)
                $FormOrTab.Controls.Add($ListView)
            }
            "ListBox" {
                $listBox            = New-Object System.Windows.Forms.ListBox
                $listBox.Location   = New-Object System.Drawing.Point($el.x,$el.y)
                $listBox.Width      = $el.Width
                $listBox.Height     = $el.Height
                $listBox.Font       = New-Object System.Drawing.Font("Courier New",$FontSize,[System.Drawing.FontStyle]::Regular)
                if($el.SelectionMode) {$listBox.SelectionMode = "$($el.SelectionMode)"}
                if($el.Items) {$el.Items | ForEach-Object {[void] $listBox.Items.Add($_)}} 
                $FormOrTabHash.Add($el.Name, $listBox)
                $FormOrTab.Controls.Add($listBox)
                
            }
            "TextBox" {
                $textBox            = New-Object System.Windows.Forms.TextBox
                $textBox.Location   = New-Object System.Drawing.Point($el.x,$el.y)
                $textBox.Size       = New-Object System.Drawing.Size($el['Size-x'],$el['Size-y'])
                $textBox.Font       = $FontStyle 
                if($el.Multiline) {$textBox.Multiline = $el.Multiline}
                if($el.PasswordChar) {$textBox.PasswordChar = $el.PasswordChar}
                if($el.DefaultText){$textBox.Text = $el.DefaultText}
                $FormOrTabHash.Add($el.Name, $textBox)
                $FormOrTab.Controls.Add($textBox)
            }
            "CheckBox" {
                $checkBox           = New-Object System.Windows.Forms.CheckBox
                $checkBox.Location  = New-Object System.Drawing.Point($el.x,$el.y)
                $checkBox.AutoSize  = $false
                $checkBox.Text      = $el.Text
                $checkBox.Font      = $FontStyle 
                if($el.Checked) {$checkBox.Checked = $el.Checked} else {$checkBox.Checked = $false}
                $FormOrTabHash.Add($el.Name, $checkBox)
                $FormOrTab.Controls.Add($checkBox)
            }
            "Calendar" {
                $Cal                    = New-Object System.Windows.Forms.MonthCalendar
                $Cal.Location           = New-Object System.Drawing.Size($el.x,$el.y)
                $Cal.ShowTodayCircle    = $true
                $Cal.MaxSelectionCount  = 1
                $FormOrTabHash.Add($el.Name, $Cal)
                $FormOrTab.Controls.Add($Cal)
            }
            Default {
                throw "$($el.Type) is not handled by form code - check your json"
            }
        }
    }
}
Export-ModuleMember -Function Set-FormElementsFromJson

# ============== LISTVIEW Helpers ==============
function Set-ListViewElementsFromData {
    #BEST to make SQL Result or imported CSV as string-like as possible. i.e. do string conversions in SQL or creation of your csv
    [CmdletBinding()]
    param (
		[Parameter(Mandatory=$true)] [System.Windows.Forms.ListView]$ListView,
        [Parameter(Mandatory=$true, HelpMessage="Data can be a csv that has been imported, a result set from SQL, or PSCustomObject")] $Data
    )
    $ListView.Items.Clear()
    foreach($row in $Data){
        $ColName = $ListView.Columns[0].Text
        $item1 = [System.Windows.Forms.ListViewItem]::new(($row."$ColName"),0)
        for($i=1;$i -lt $ListView.Columns.count;$i++){
          $ColName = $ListView.Columns[$i].Text
          $item1.SubItems.Add([string]$row."$ColName") | Out-Null 
        }
        $ListView.Items.Add($item1) | Out-Null
      }
}
Export-ModuleMember -Function Set-ListViewElementsFromData
function New-LineDataFromListViewItem {
    [CmdletBinding()]
    param (
		[Parameter(Mandatory=$true)] $item
    )
    $data = @{}
    $i=0
    foreach($col in $item.ListView.Columns){
        $data.Add($col.Text,$item.SubItems[$i].Text)
        $i++
    }
    return $data
}
Export-ModuleMember -Function New-LineDataFromListViewItem
