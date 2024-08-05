# Set MISP API Key/URI Context
function Get-MispTag {
    <#
    .SYNOPSIS
        Get MISP Tag(s)
    .DESCRIPTION
        Get MISP Tag(s)

        If no Tag ID is supplied, all tags are returned
    .PARAMETER Context
        PSCustomObject with containing the MISP Context
    .PARAMETER Id
        Id of a specific tag
    .PARAMETER Criteria
        Search criteria in SQL Match format. eg. "%banana%"
    .INPUTS
        [PsCustomObject]    -> Context
        [Int]               -> Id
        [string]            -> Criteria
    .OUTPUTS
        [Array]             -> Array of tags
    .EXAMPLE
        PS> $Tags = Get-MispTag -Context $MispContext
        Return all Tags
    .EXAMPLE
        PS> $Event = Get-MispTag -Context $MispContext -Id 1234
        Return details for tag 1234
    .EXAMPLE
        PS> $Event = Get-MispTag -Context $MispContext -Criteria '%banana%'
        Return all tags containing the text 'banana'
    .LINK
        https://github.com/IPSecMSSP/misp.tools
        https://www.circl.lu/doc/misp/automation/#attribute-management
    #>

  [CmdletBinding(DefaultParameterSetName='ListAll')]

  param (
    [Parameter(Mandatory=$true)]
    [PsCustomObject]$Context,

    [Parameter(
      Mandatory=$false,
      ParameterSetName='ById'
      )]
    [Int]$Id,

    [Parameter(
      Mandatory=$false,
      ParameterSetName='ByCriteria'
    )]
    [string]$Criteria
  )

  Begin {
    $Me = $MyInvocation.MyCommand.Name

    Write-Verbose "$($Me): Get MISP Attribute(s)"

    # If we don't "Clone" the UriBuilder object from the Context, the Context's instance of the BaseUri gets updated. We do not want that.
    $Uri = [System.UriBuilder]$Context.BaseUri.ToString()
    $Uri.Path = [io.path]::combine($Uri.Path, "tags")

    # Append the Event Id if requested
    if ($MyInvocation.BoundParameters.ContainsKey("Id")) {
      $Uri.Path = [io.path]::combine($Uri.Path, "view/$($Id)")
    } elseif ($PSCmdlet.ParameterSetName -eq 'ByCriteria') {
      $Uri.Path = [io.path]::Combine($Uri.Path, "search/$($Criteria)")
    }
  }

  Process {

    # Call the API
    $Response = Invoke-MispRestMethod -Context $Context -Uri $Uri

    if ($MyInvocation.BoundParameters.ContainsKey("Id")) {
      # Only a single event was requested
      Write-Output $Response
    } elseif ($PSCmdlet.ParameterSetName -eq 'ByCriteria') {
      Write-Output $Response.Tag
    } else {
      # Return all fo the events
      Write-Output $Response.Tag
    }

  }

  End {

  }

}