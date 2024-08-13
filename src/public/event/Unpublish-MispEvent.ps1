# Set MISP API Key/URI Context
function Unpublish-MispEvent {
    <#
    .SYNOPSIS
        Unpublish an existing MISP Event
    .DESCRIPTION
        Unpublish an existing MISP Event

        Unmark the Event identified by the id (numeric or UUID) as published
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

    Write-Verbose ('{0}: Unpublish MISP Event(s)' -f $Me)

    # If we don't "Clone" the UriBuilder object from the Context, the Context's instance of the BaseUri gets updated. We do not want that.
    $Uri = [System.UriBuilder]$Context.BaseUri.ToString()
    $Uri.Path = [io.path]::combine($Uri.Path, 'events/unpublish')
  }

  Process {
    $Uri.Path = [io.path]::combine($Uri.Path, $Id)

    If ($PSCmdlet.ShouldProcess("Unpublish MISP Event")) {
      # Call the API
      $Response = Invoke-MispRestMethod -Context $Context -Uri $Uri -Method "POST"
    }

    Write-Output $Response

  }

  End {

  }

}