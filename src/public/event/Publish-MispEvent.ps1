# Set MISP API Key/URI Context
function Publish-MispEvent {
    <#
    .SYNOPSIS
        Publish an existing MISP Event
    .DESCRIPTION
        Publish an existing MISP Event

        Mark the Event identified by the id (numeric or UUID) as published
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
        PS> $Events = New-MispEvent -Context $MispContext
        Return first all Events
    .EXAMPLE
        PS> $Event = New-MispEvent -Context $MispContext -Id 1234
        Return details for event 1234
    .LINK
        https://github.com/IPSecMSSP/misp.tools
        https://www.circl.lu/doc/misp/automation/#events-management
    #>

  [CmdletBinding(SupportsShouldProcess)]

  param (
    [Parameter(Mandatory=$true)]
    [PsCustomObject]$Context,

    [Parameter(Mandatory=$true)]
    [string]$Id
    )

  Begin {
    $Me = $MyInvocation.MyCommand.Name

    Write-Verbose ('{0}: Publish MISP Event(s)' -f $Me)

    # If we don't "Clone" the UriBuilder object from the Context, the Context's instance of the BaseUri gets updated. We do not want that.
    $Uri = [System.UriBuilder]$Context.BaseUri.ToString()
    $Uri.Path = [io.path]::combine($Uri.Path, 'events/publish')
  }

  Process {
    $Uri.Path = [io.path]::combine($Uri.Path, $Id)

    If ($PSCmdlet.ShouldProcess("Publish MISP Event")) {
      # Call the API
      $Response = Invoke-MispRestMethod -Context $Context -Uri $Uri -Method "POST"
    }

    Write-Output $Response

  }

  End {

  }

}