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