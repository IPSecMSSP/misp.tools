# Set MISP API Key/URI Context
function Add-MispEventTag {
    <#
    .SYNOPSIS
        Add a tag to a MISP Event
    .DESCRIPTION
        Add a tag to a MISP Event

        An event may have one or more tags associated.  This can assist with the filtering and grouping of events
    .PARAMETER Context
        PSCustomObject with containing the MISP Context
    .PARAMETER TagId
        Id of tag to add to Event
    .PARAMETER EventId
        Id of event to which tag should be added
    .PARAMETER Local
        Whether the tag should be attached locally or not to the event
    .INPUTS
        [PsCustomObject]    -> Context
        [Int]               -> TagId
        [Int]               -> EventId
        [switch]            -> Local
    .OUTPUTS
        None if successful
    .EXAMPLE
        PS> $Tags = Add-MispEventTag -Context $MispContext -EventId 1234 -TagId 69 -Local
        Add Tag with Id 69 to event Id 1234, locally
    .LINK
        https://url.to.repo/repo/path/
        https://www.circl.lu/doc/misp/automation/#attribute-management
    #>

  [CmdletBinding()]

  param (
    [Parameter(Mandatory=$true)]
    [PsCustomObject]$Context,

    [Parameter(
      Mandatory=$true
      )]
    [Int]$EventId,

    [Parameter(
      Mandatory=$true
      )]
    [Int]$TagId,

    [Parameter(
      Mandatory=$false
    )]
    [switch] $Local
  )

  Begin {
    $Me = $MyInvocation.MyCommand.Name

    Write-Verbose "$($Me): Add Tag to MISP Event"

    if($Local) {
      $TagLocal = 1
    } else {
      $TagLocal = 0
    }

    # If we don't "Clone" the UriBuilder object from the Context, the Context's instance of the BaseUri gets updated. We do not want that.
    $Uri = [System.UriBuilder]$Context.BaseUri.ToString()
    $Uri.Path = [io.path]::combine($Uri.Path, ("events/addTag/{0}/{1}/local:{2}" -f $EventId, $TagId, $TagLocal))

  }

  Process {

    # Call the API
    $Response = Invoke-MispRestMethod -Context $Context -Uri $Uri

    if (!$Response.saved) {
      Write-Warning "Unable to add tag to Event"
    }
  }

  End {

  }

}