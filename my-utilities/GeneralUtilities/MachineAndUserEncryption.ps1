# START From https://stackoverflow.com/questions/46400234/encrypt-string-with-the-machine-key-in-powershell
# Added proper naming converntions and encrypted with User and Machine
Function Protect-WithMachineAndUserKey($s) {
    Add-Type -AssemblyName System.Security

    $bytes = [System.Text.Encoding]::Unicode.GetBytes($s)
    $SecureStr = [Security.Cryptography.ProtectedData]::Protect($bytes, $null, [Security.Cryptography.DataProtectionScope]::LocalMachine)
    $SecureStr = [Security.Cryptography.ProtectedData]::Protect($SecureStr, $null, [Security.Cryptography.DataProtectionScope]::CurrentUser)
    $SecureStrBase64 = [System.Convert]::ToBase64String($SecureStr)
    return $SecureStrBase64
}
Export-ModuleMember -Function Protect-WithMachineAndUserKey

Function Unprotect-WithMachineAndUserKey($s) {
    Add-Type -AssemblyName System.Security
    $SecureStr = [System.Convert]::FromBase64String($s)
    $bytes = [Security.Cryptography.ProtectedData]::Unprotect($SecureStr, $null, [Security.Cryptography.DataProtectionScope]::CurrentUser)
    $bytes = [Security.Cryptography.ProtectedData]::Unprotect($bytes, $null, [Security.Cryptography.DataProtectionScope]::LocalMachine)
    $Password = [System.Text.Encoding]::Unicode.GetString($bytes)
    return $Password
}
Export-ModuleMember -Function Unprotect-WithMachineAndUserKey
# END From https://stackoverflow.com/questions/46400234/encrypt-string-with-the-machine-key-in-powershell

Function Protect-WithUserKey($s) {
    Add-Type -AssemblyName System.Security
    $bytes = [System.Text.Encoding]::Unicode.GetBytes($s)
    $SecureStr = [Security.Cryptography.ProtectedData]::Protect($bytes, $null, [Security.Cryptography.DataProtectionScope]::CurrentUser)
    $SecureStrBase64 = [System.Convert]::ToBase64String($SecureStr)
    return $SecureStrBase64
}
Export-ModuleMember -Function Protect-WithUserKey

Function Unprotect-WithUserKey($s) {
    Add-Type -AssemblyName System.Security
    $SecureStr = [System.Convert]::FromBase64String($s)
    $bytes = [Security.Cryptography.ProtectedData]::Unprotect($SecureStr, $null, [Security.Cryptography.DataProtectionScope]::CurrentUser)
    $Password = [System.Text.Encoding]::Unicode.GetString($bytes)
    return $Password
}
Export-ModuleMember -Function Unprotect-WithUserKey

function Add-SecureKeyToLocalStore{
[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)] [string]$Key,
    [Parameter(Mandatory=$true)] [String]$Value,
    [Parameter(Mandatory=$true, HelpMessage="Full filename, unless using switch to make relative to MyDocuments")] [String]$StoreFileName,
    [Parameter(Mandatory=$false)] [Switch]$UseMyDocuments,
    [Parameter(Mandatory=$false)] [Switch]$UserKeyOnly
) 
    if ($UseMyDocuments){$StoreFileName = Join-Path ([Environment]::GetFolderPath("MyDocuments")) $StoreFileName}
    if (Test-Path $StoreFileName){
        Write-Debug "$StoreFileName exists"
        $keys = Get-Content $StoreFileName -Raw | ConvertFrom-Json | ConvertTo-HashtableV5
    } else {
        Write-Host "$StoreFileName does not exist, will create"
        $keys = @{}
    }
    if ($UserKeyOnly){
        if ($keys.ContainsKey($Key)){
            $keys[$Key] = (Protect-WithUserKey $Value)
        } else {
            $keys.Add($Key, (Protect-WithUserKey $Value))
        }
    } else {
        if ($keys.ContainsKey($Key)){
            $keys[$Key] = (Protect-WithMachineAndUserKey $Value)
        } else {
            $keys.Add($Key, (Protect-WithMachineAndUserKey $Value))
        }
    }

    $keys | ConvertTo-Json | Set-Content $StoreFileName -Force
}
Export-ModuleMember -Function Add-SecureKeyToLocalStore
function Get-SecureKeyFromLocalStore{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)] [string]$Key,
        [Parameter(Mandatory=$true, HelpMessage="Full filename, unless using switch to make relative to MyDocuments")] [String]$StoreFileName,
        [Parameter(Mandatory=$false)] [Switch]$UseMyDocuments,
        [Parameter(Mandatory=$false)] [Switch]$UserKeyOnly
    ) 
    if ($UseMyDocuments){$StoreFileName = Join-Path ([Environment]::GetFolderPath("MyDocuments")) $StoreFileName}
    if (Test-Path $StoreFileName){
        $keys = Get-Content $StoreFileName -Raw | ConvertFrom-Json  | ConvertTo-HashtableV5
        If($keys.ContainsKey($key)) {
            if ($UserKeyOnly){
                Return Unprotect-WithUserKey $keys.$key
            } else {
                Return Unprotect-WithMachineAndUserKey $keys.$key
            }
            
        } else {throw "$StoreFileName does not contain $key"}
    } else {throw "$StoreFileName does not exist"}
}
Export-ModuleMember -Function Get-SecureKeyFromLocalStore

function Remove-SecureKeyFromLocalStore{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)] [string]$Key,
        [Parameter(Mandatory=$true, HelpMessage="Full filename, unless using switch to make relative to MyDocuments")] [String]$StoreFileName,
        [Parameter(Mandatory=$false)] [Switch]$UseMyDocuments
    ) 
    if ($UseMyDocuments){$StoreFileName = Join-Path ([Environment]::GetFolderPath("MyDocuments")) $StoreFileName}
    if (Test-Path $StoreFileName){
        $keys = Get-Content $StoreFileName -Raw | ConvertFrom-Json  | ConvertTo-HashtableV5
        If($keys.ContainsKey($key)) {
            $keys.Remove($Key)
            $keys | ConvertTo-Json | Set-Content $StoreFileName -Force
        } else {throw "$StoreFileName does not contain $key"}
    } else {throw "Keystore '$StoreFileName' does not exist"}
}
Export-ModuleMember -Function Remove-SecureKeyFromLocalStore