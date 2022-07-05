# Set MISP API Key/URI Context
function Get-MispEvent {
    <#
    .SYNOPSIS
        Get MISP Event(s)
    .DESCRIPTION
        Get MISP Event(s)

        If no Event ID is supplied, the first 100 events are returned
    .PARAMETER Context
        PSCustomObject with containing the MISP Context
    .PARAMETER Id
        Id of a specific event
    .INPUTS
        [PsCustomObject]    -> Context
        [Int]               -> Id
    .OUTPUTS
        [Array]             -> Array of Events
    .EXAMPLE
        PS> $Events = Get-MispEvent -Context $MispContext
        Return first 100 events
    .EXAMPLE
        PS> $Event = Get-MispEvent -Context $MispContext -Id 1234
        Return details for event 1234
    .LINK
        https://url.to.repo/repo/path/
    #>

  [CmdletBinding()]

  param (
    [Parameter(Mandatory=$true)]
    [PsCustomObject]$Context,

    [Parameter(Mandatory=$false)]
    [Int]$Id
  )

  Begin {
    $Me = $MyInvocation.MyCommand.Name

    Write-Verbose "$($Me): Get MISP Event(s)"

    if ($MyInvocation.BoundParameters.ContainsKey("Id")) {
      $Uri.Path += "/events/$($Id)"

    } else {
      $Uri.Path += "/events"
    }
  }

  Process {
    # Set SSL Preferences/Certificate Trust Policy
    Enable-TrustAllCertsPolicy

    $Response = Invoke-MispRestMethod -Context $Context -Uri $Uri

    if ($MyInvocation.BoundParameters.ContainsKey("Id")) {
      Write-Output $Response.Event
    } else {
      Write-Output $Response
    }

  }

  End {

  }

}