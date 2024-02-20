# START From https://stackoverflow.com/questions/46400234/encrypt-string-with-the-machine-key-in-powershell
Function Protect-WithMachineKey($s) {
    Add-Type -AssemblyName System.Security

    $bytes = [System.Text.Encoding]::Unicode.GetBytes($s)
    $SecureStr = [Security.Cryptography.ProtectedData]::Protect($bytes, $null, [Security.Cryptography.DataProtectionScope]::LocalMachine)
    $SecureStrBase64 = [System.Convert]::ToBase64String($SecureStr)
    return $SecureStrBase64
}
Export-ModuleMember -Function Protect-WithMachineKey

Function Unprotect-WithMachineKey($s) {
    Add-Type -AssemblyName System.Security

    $SecureStr = [System.Convert]::FromBase64String($s)
    $bytes = [Security.Cryptography.ProtectedData]::Unprotect($SecureStr, $null, [Security.Cryptography.DataProtectionScope]::LocalMachine)
    $Password = [System.Text.Encoding]::Unicode.GetString($bytes)
    return $Password
}
Export-ModuleMember -Function Unprotect-WithMachineKey
# END From https://stackoverflow.com/questions/46400234/encrypt-string-with-the-machine-key-in-powershell
function Add-SecureKeyToLocalStore{
[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)] [string]$Key,
    [Parameter(Mandatory=$true)] [String]$Value,
    [Parameter(Mandatory=$true, HelpMessage="Full filename, unless using switch to make relative to MyDocuments")] [String]$StoreFileName,
    [Parameter(Mandatory=$false)] [Switch]$UseMyDocuments
) 
    if ($UseMyDocuments){$StoreFileName = Join-Path ([Environment]::GetFolderPath("MyDocuments")) $StoreFileName}
    if (Test-Path $StoreFileName){
        Write-Debug "$StoreFileName exists"
        $keys = Get-Content $StoreFileName -Raw | ConvertFrom-Json | ConvertTo-HashtableV5
    } else {
        Write-Host "$StoreFileName does not exist, will create"
        $keys = @{}
    }
    if ($keys.ContainsKey($Key)){
        $keys[$Key] = (Protect-WithMachineKey $Value)
    } else {
        $keys.Add($Key, (Protect-WithMachineKey $Value))
    }
    $keys | ConvertTo-Json | Set-Content $StoreFileName -Force
}
Export-ModuleMember -Function Add-SecureKeyToLocalStore
function Get-SecureKeyFromLocalStore{
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
            Return UnProtect-WithMachineKey $keys.$key
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