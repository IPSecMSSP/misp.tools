# Set MISP API Key/URI Context
function Get-MispEvent {
    <#
    .SYNOPSIS
        Get MISP Event(s)
    .DESCRIPTION
        Get MISP Event(s)

        If no Event ID is supplied, all events are returned
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
        Return first all Events
    .EXAMPLE
        PS> $Event = Get-MispEvent -Context $MispContext -Id 1234
        Return details for event 1234
    .LINK
        https://github.com/IPSecMSSP/misp.tools
        https://www.circl.lu/doc/misp/automation/#events-management
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

    # If we don't "Clone" the UriBuilder object from the Context, the Context's instance of the BaseUri gets updated. We do not want that.
    $Uri = [System.UriBuilder]$Context.BaseUri.ToString()
    $Uri.Path = [io.path]::combine($Uri.Path, "events")

    # Append the Event Id if requested
    if ($MyInvocation.BoundParameters.ContainsKey("Id")) {
      $Uri.Path = [io.path]::combine($Uri.Path, $Id)
    }
  }

  Process {

    # Call the API
    $Response = Invoke-MispRestMethod -Context $Context -Uri $Uri

    if ($MyInvocation.BoundParameters.ContainsKey("Id")) {
      # Only a single event was requested
      Write-Output $Response.Event
    } else {
      # Return all fo the events
      Write-Output $Response
    }

  }

  End {

  }

}