function New-SampleForm {
    [CmdletBinding()]
    param ()
    # ===== TOP ===== 
    $FormJson =  $PSCommandPath.Replace(".ps1",".json")
    $NewForm, $FormElements = Set-FormFromJson $FormJson

    # ===== Single Tab =====

    function LoadMyDb(){
      $Global:MyDb = Get-MyLocalDBList $MyDbPath
      $FormElements.list_Contacts.Items.Clear()
      $Header = "ID   Name            Company       Ph"
      [void] $FormElements.list_Contacts.Items.Add($Header)
      Foreach ($Record in $MyDb.Keys | Sort-Object){
        $Line = ([string]$Record).PadRight(4, " ") + " "+`
                ([string]$MyDb[$Record].name).PadRight(15, " ") + " "+`
                ([string]$MyDb[$Record].company).PadRight(13, " ") + " "+`
                ([string]$MyDb[$Record].phone).PadRight(12, " ") + " "
        [void] $FormElements.list_Contacts.Items.Add($Line)
      } 
    }

    function ClearFields(){
      $FormElements.textBox_Name.text = ""
      $FormElements.combo_Company.SelectedIndex = 0
      $FormElements.textBox_Phone.text = ""
    }

    $FormElements.list_Contacts.add_SelectedIndexChanged({
      if ($FormElements.list_Contacts.SelectedIndex -ge 1){
        $Id=[int](($FormElements.list_Contacts.SelectedItem).split(" ")[0])
        Write-Host "Selected contact $Id"
        $FormElements.textBox_Name.text = $MyDb[$id].name
        $FormElements.combo_Company.SelectedItem = $MyDb[$id].company
        $FormElements.textBox_Phone.text = $MyDb[$id].phone
        $Global:SelectedContact = $Id
      } else {
        ClearFields
        $Global:SelectedContact = 0
      }
    })

    $FormElements.button_update.Add_Click({
      Write-Host "Selected contact $SelectedContact for update"
      if ($SelectedContact -ge 1){
        $MyDb[$SelectedContact].name = $FormElements.textBox_Name.text
        $MyDb[$SelectedContact].company = $FormElements.combo_Company.SelectedItem
        $MyDb[$SelectedContact].phone = $FormElements.textBox_Phone.text
        Save-MyLocalDBList $MyDb $MyDbPath
        LoadMyDb
        ClearFields
      } else {
        throw "Select a contact first"
      }
    })
    
    $FormElements.button_save_new.Add_Click({
      Write-Host "Adding new contact"
      $Name = $FormElements.textBox_Name.text = ($FormElements.textBox_Name.text).trim()
      $Company = $FormElements.combo_Company.SelectedItem
      $Phone = $FormElements.textBox_Phone.text = ($FormElements.textBox_Phone.text).trim()
      if (($Name -eq "") -or ($Phone -eq "")){
        throw "Must enter a value for Name and phone"
      } else {
        Add-ToMyLocalDBList $Name $Company $Phone $MyDb $MyDbPath
        LoadMyDb
        ClearFields
      }
    })
    
    $FormElements.button_remove.Add_Click({
      Write-Host "Selected contact $SelectedContact for removal"
      if ($SelectedContact -ge 1){
        $MyDB.Remove($SelectedContact)
        Save-MyLocalDBList $MyDb $MyDbPath
        LoadMyDb
        ClearFields
      } else {
        throw "Select a contact first"
      }
    })

    $FormElements.button_Tram.Add_Click({
      $TramStop = ($FormElements.combo_Trams.SelectedItem).split("|")[0].trim()
      $Route = ($FormElements.combo_Trams.SelectedItem).split(" ")[3].trim()
      Write-Host "Next 3 trams for stop $TramStop, route $Route"
      Get-Next3TramsMinutes $TramStop $Route | ForEach-Object{
        Write-Host "$_ minutes"
      }
    })

    # ===== LOAD at runtime ===== 
    $Global:MyDb = @{}
    $Global:MyDbPath = "$(Split-Path $PSCommandPath)\MyDb.csv"
    $Global:SelectedContact = 0
    LoadMyDb

    # ===== BOTTOM ===== 
    $NewForm.ShowDialog()
}
Export-ModuleMember -Function New-SampleForm