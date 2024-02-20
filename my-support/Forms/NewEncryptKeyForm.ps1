function New-EncryptKeyForm {
    [CmdletBinding()]
    param ()
    # ===== TOP ===== 
    $FormJson =  $PSCommandPath.Replace(".ps1",".json")
    $NewForm, $FormElements = Set-FormFromJson $FormJson

    # ===== Single Tab =====
    function LoadKeys(){
      if (Test-Path $FullFileName){
        $Global:SecureKeys = @()
        $data = Get-Content $FullFileName -Raw | ConvertFrom-Json | ConvertTo-HashtableV5
        foreach($key in $data.Keys){
          $Global:SecureKeys += @{"Key"=$key; "EncryptedData"=$data[$key]}
        }
        Set-ListViewElementsFromData -ListView $FormElements.list_SecureKeyKeyList -Data ($Global:SecureKeys | Sort-Object { $_.Key })
      }
    }

    $FormElements.list_SecureKeyKeyList.Add_ItemSelectionChanged({
      $data = New-LineDataFromListViewItem $_.Item #gives you access to known columns in csv
      if($_.IsSelected){
        $UnEncryptedValue = Unprotect-WithMachineKey ($data."EncryptedData")
        $FormElements.textBox_SecureKeyNewKey.Text = $data."Key"
        $FormElements.textBox_SecureKeyNewKeyValue.Text = $UnEncryptedValue
      }
    })

    $FormElements.button_SecureKeyAdd.Add_Click({
      $UpdateKey = $FormElements.textBox_SecureKeyNewKey.text = ($FormElements.textBox_SecureKeyNewKey.text).trim()
      $Update = $FormElements.textBox_SecureKeyNewKeyValue.text = ($FormElements.textBox_SecureKeyNewKeyValue.text).trim()
      if (($Update -eq "") -or ($UpdateKey -eq "")){throw "Cannot update blank key or value"}
      Add-SecureKeyToLocalStore -Key $UpdateKey -Value $Update -StoreFileName $FullFileName
      LoadKeys
      $FormElements.textBox_SecureKeyNewKey.text = ""
      $FormElements.textBox_SecureKeyNewKeyValue.text = ""
    })

    $FormElements.button_SecureKeyRemove.Add_Click({
      $UpdateKey = $FormElements.textBox_SecureKeyNewKey.text = ($FormElements.textBox_SecureKeyNewKey.text).trim()
      if ($Update -eq ""){throw "Cannot remove a blank key"}
      $SelectedI = $FormElements.list_SecureKeyKeyList.SelectedIndices
      if($SelectedI.count -ne 1){
        throw "You must select 1 line only when deleting"
      } else {
        Remove-SecureKeyFromLocalStore -Key $UpdateKey -StoreFileName $FullFileName
        LoadKeys
        $FormElements.textBox_SecureKeyNewKey.text = ""
        $FormElements.textBox_SecureKeyNewKeyValue.text = ""
      }
    })
    
    # == CONST ==
    $FileName = "MyStuff"
    $FullFileName = Join-Path ([Environment]::GetFolderPath("MyDocuments")) $FileName
    
    # == vault 'in memory'
    $Global:SecureKeys = @() #because it changes it needs to be always Global

    # == Initialise
    LoadKeys

    # ===== BOTTOM ===== 
    $NewForm.ShowDialog()
}
Export-ModuleMember -Function New-EncryptKeyForm