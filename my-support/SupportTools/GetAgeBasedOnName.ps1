function Get-AgeBasedOnName {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)] $Name
    )
    $res = Invoke-WebRequest ("https://api.agify.io/?name={0}" -f $Name) -Method Get
    $Age = (ConvertFrom-Json $res.Content).Age
    $Count = (ConvertFrom-Json $res.Content).count
    Return $Age,$Count
}
Export-ModuleMember -Function Get-AgeBasedOnName