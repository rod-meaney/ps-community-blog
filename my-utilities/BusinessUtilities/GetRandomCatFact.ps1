function Get-RandomCatFact {
    [CmdletBinding()]
    param ()
    $res = Invoke-WebRequest "https://catfact.ninja/fact" -Method Get
    $fact = (ConvertFrom-Json $res.Content).fact
    Return $fact
}
Export-ModuleMember -Function Get-RandomCatFact