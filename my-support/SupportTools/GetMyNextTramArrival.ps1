function Get-MyNextTramArrival {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)] $TramStop="1649",
        [Parameter(Mandatory=$false)] $Route="72"
    )
    $Result = Get-Next3TramsMinutes -TramStop $TramStop -Route $Route
    If ($Result.Count -lt 1){throw "There are no trams coming!"}
    Return $Result[0]
}
Export-ModuleMember -Function Get-MyNextTramArrival