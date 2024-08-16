function Add-MispAttributeToEvent {
  <#
    .SYNOPSIS
        Add one or more MISP Attributes to an Event
    .DESCRIPTION
        Add one or more MISP Attributes to an Event

        Take the provided details and use these to Add additional Attributes to a MISP event
    .PARAMETER Context
        PSCustomObject with containing the MISP Context
    .PARAMETER Id
        Id of MISP event to add attributes to
    .PARAMETER Attribute
        Array of Attributes to attach ot the event. Each attribute consist of a Value and Type at minimum, and may include IPs, hostnames, file hashes, etc.

        You can create a suitable attribute using New-MispAttribute.
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
    [Parameter(Mandatory = $true)]
    [PsCustomObject]$Context,

    [Parameter(Mandatory = $true)]
    [int]$Id,

    [Parameter(Mandatory = $false)]
    [array] $Attribute
  )

  Begin {
    $Me = $MyInvocation.MyCommand.Name

    Write-Verbose "$($Me): Add Attributes to MISP Event"

    # If we don't "Clone" the UriBuilder object from the Context, the Context's instance of the BaseUri gets updated. We do not want that.
    $Uri = [System.UriBuilder]$Context.BaseUri.ToString()
    $Uri.Path = [io.path]::combine($Uri.Path, "attributes/add", $Id)

  }

  Process {

    if ($PSCmdlet.ShouldProcess(("EventID: {0}" -f $EventId), "Add Attribute")) {
      foreach ($Entry in $Attribute) {
        Write-Verbose ('{0}: Adding attribute Value {1}, Type {2}' -f $Me, $Entry.value, $Entry.type)
        Write-Debug ($Entry | ConvertTo-json)
        # Add each Attribute to the Event in turn
        $AttrResp = Invoke-MispRestMethod -Context $Context -Uri $Uri -Method POST -Body $Entry

        Write-Verbose ('{0}: Added attribute ID {1}' -f $Me, $AttrResp.Id)
      }

    }

  }

  End {

  }

}