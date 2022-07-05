# Set MISP API Key/URI Context
function Get-MispEvent {
    <#
    .SYNOPSIS
        Get MISP Attribute(s)
    .DESCRIPTION
        Get MISP Attribute(s)

        If no Attribute ID is supplied, all attributes are returned
    .PARAMETER Context
        PSCustomObject with containing the MISP Context
    .PARAMETER Id
        Id of a specific event
    .INPUTS
        [PsCustomObject]    -> Context
        [Int]               -> Id
    .OUTPUTS
        [Array]             -> Array of Attributes
    .EXAMPLE
        PS> $Attributes = Get-MispAttribute -Context $MispContext
        Return all Attributes
    .EXAMPLE
        PS> $Event = Get-MispAttribute -Context $MispContext -Id 1234
        Return details for attribute 1234
    .LINK
        https://url.to.repo/repo/path/
        https://www.circl.lu/doc/misp/automation/#attribute-management
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

    Write-Verbose "$($Me): Get MISP Attribute(s)"

    # If we don't "Clone" the UriBuilder object from the Context, the Context's instance of the BaseUri gets updated. We do not want that.
    $Uri = [System.UriBuilder]$Context.BaseUri.ToString()
    $Uri.Path = [io.path]::combine($Uri.Path, "attributes")

    # Append the Event Id if requested
    if ($MyInvocation.BoundParameters.ContainsKey("Id")) {
      $Uri.Path = [io.path]::combine($Uri.Path, "view/$($Id)")
    }
  }

  Process {

    # Call the API
    $Response = Invoke-MispRestMethod -Context $Context -Uri $Uri

    if ($MyInvocation.BoundParameters.ContainsKey("Id")) {
      # Only a single event was requested
      Write-Output $Response.Attribute
    } else {
      # Return all fo the events
      Write-Output $Response
    }

  }

  End {

  }

}