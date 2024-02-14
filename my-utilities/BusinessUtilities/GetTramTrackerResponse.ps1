#based on http://tramtracker.com.au/
function Get-TramTrackerResponse {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)] $TramStop,
        [Parameter(Mandatory=$true)] $Route
    )
    #$TramStop='1649'
    #$Route='72'
    $URL = "http://tramtracker.com.au/Controllers/GetNextPredictionsForStop.ashx?stopNo={0}&routeNo={1}&isLowFloor=false&ts={2}"
    $EpochTime = Get-Date -UFormat %s
    Write-Verbose "Current Epoch: $($EpochTime)"
    $Result = Invoke-WebRequest -Uri ($URL -f $TramStop,$Route,$EpochTime) -Method Get
    Return $Result.Content
}

Export-ModuleMember -Function Get-TramTrackerResponse