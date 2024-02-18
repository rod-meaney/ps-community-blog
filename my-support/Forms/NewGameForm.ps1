function New-GameForm {
    [CmdletBinding()]
    param ()
    # ===== TOP ===== 
    $FormJson =  $PSCommandPath.Replace(".ps1",".json")
    $NewForm, $FormElements = Set-FormFromJson $FormJson

    # ===== Single Tab =====
    $FormElements.button_GameGuess.Add_Click({
      $Guess = $FormElements.combo_GameNumber.SelectedItem
      $Roll = 1,2,3,4,5 | Get-Random
      $result = "You LOSE."
      if ($Roll -eq [int]$Guess){$result = "You WIN."}
      Write-Host "$result You guessed $Guess, machine guessed $Roll"
    })

    # ===== BOTTOM ===== 
    $NewForm.ShowDialog()
}
Export-ModuleMember -Function New-GameForm