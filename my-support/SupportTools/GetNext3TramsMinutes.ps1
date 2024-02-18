#based on http://tramtracker.com.au/
function Get-Next3TramsMinutes {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)] $TramStop,
        [Parameter(Mandatory=$true)] $Route
    )
    #$TramStop='1649'
    $JsonResp = Get-TramTrackerResponse -TramStop $TramStop -Route $Route
    $ResultObj = ConvertFrom-Json $JsonResp
    $CurrentDT = Get-Date
    $OutItems = New-Object System.Collections.Generic.List[System.Object]
    foreach($tram in $ResultObj.responseObject){
        Write-Verbose "Response: $($tram.PredictedArrivalDateTime)"
        try {
            $TramDT = Get-Date $tram.PredictedArrivalDateTime
        } catch {
            #PowerShell 5 does not do nice conversions from JSON into Dates for epoch
            #/Date(1689570258000+1000)/ -> we want 1689570258 and then to add on time offset (igoring +1000 - just easier)
            $EpochTime = ($tram.PredictedArrivalDateTime).split("+")[0].split("(")[1]/1000 + [int](get-date -UFormat %Z)*3600
            $TramDT = ([System.DateTimeOffset]::FromUnixTimeSeconds($EpochTime)).DateTime
        }
        $OutItems.Add((NEW-TIMESPAN –Start $CurrentDT –End $TramDT).Minutes) | Out-Null
    }
    Return $OutItems
}

Export-ModuleMember -Function Get-Next3TramsMinutes