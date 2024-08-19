# Set MISP API Key/URI Context
function Get-MispGalaxyCluster {
  <#
    .SYNOPSIS
        Get MISP Galaxy clusters
    .DESCRIPTION
        Get MISP Galaxy Clusters

        If no Galaxy Cluster ID is supplied, all galaxy clusters are returned
    .PARAMETER Context
        PSCustomObject with containing the MISP Context
    .PARAMETER GalaxyId
        Id of a specific galaxy
    .PARAMETER Id
        Id of a specific galaxy cluster
    .PARAMETER Criteria
        Search criteria in SQL Match format. eg. "%banana%"
    .INPUTS
        [PsCustomObject]    -> Context
        [Int]               -> Id
        [string]            -> Criteria
    .OUTPUTS
        [Array]             -> Array of tags
    .EXAMPLE
        PS> $Tags = Get-MispGalaxy -Context $MispContext
        Return all Tags
    .EXAMPLE
        PS> $Event = Get-MispGalaxy -Context $MispContext -Id 1234
        Return details for galaxy 1234
    .EXAMPLE
        PS> $Event = Get-MispGalaxy -Context $MispContext -Criteria '%banana%'
        Return all galaxies containing the text 'banana'
    .LINK
        https://github.com/IPSecMSSP/misp.tools
        https://www.circl.lu/doc/misp/automation/#attribute-management
    #>

  [CmdletBinding(DefaultParameterSetName = 'ListAll')]

  param (
    [Parameter(Mandatory = $true)]
    [PsCustomObject]$Context,

    [Parameter(Mandatory = $true)]
    [Int]$GalaxyId,

    [Parameter(
      Mandatory = $false,
      ParameterSetName = 'ById'
    )]
    [Int]$Id,

    [Parameter(
      Mandatory = $false,
      ParameterSetName = 'ByCriteria'
    )]
    [string]$Criteria,

    [Parameter(Mandatory = $false)]
    [ValidateSet('all', 'default', 'org', 'deleted')]
    [string]$SearchContext = 'default'
  )

  Begin {
    $Me = $MyInvocation.MyCommand.Name

    Write-Verbose "$($Me): Get MISP Galaxy Cluster(s)"

    # Default Method
    $Method = 'GET'

    # If we don't "Clone" the UriBuilder object from the Context, the Context's instance of the BaseUri gets updated. We do not want that.
    $Uri = [System.UriBuilder]$Context.BaseUri.ToString()
    $Uri.Path = [io.path]::combine($Uri.Path, "galaxy_clusters")

    # Append the Event Id if requested
    if ($MyInvocation.BoundParameters.ContainsKey("Id")) {
      $Uri.Path = [io.path]::combine($Uri.Path, "view", $Id)
    }
    elseif ($PSCmdlet.ParameterSetName -eq 'ByCriteria') {
      $Uri.Path = [io.path]::combine($Uri.Path, "index", $GalaxyId)
      $Method = 'POST'
      $SearchBody = @{
        context   = $SearchContext
        searchall = $Criteria
      }
    }
    else {
      $Uri.Path = [io.path]::combine($Uri.Path, "index", $GalaxyId)
    }
  }

  Process {

    # Call the API
    if ($MyInvocation.BoundParameters.ContainsKey('ByCriteria')) {
      $Response = Invoke-MispRestMethod -Context $Context -Uri $Uri -Method $Method -Body $SearchBody
    }
    else {
      $Response = Invoke-MispRestMethod -Context $Context -Uri $Uri -Method $Method
    }

    if ($MyInvocation.BoundParameters.ContainsKey("Id")) {
      # Only a single galaxy cluster was requested
      Write-Output $Response
    }
    elseif ($PSCmdlet.ParameterSetName -eq 'ByCriteria') {
      Write-Output $Response.GalaxyCluster
    }
    else {
      # Return all fo the galaxy clusters
      Write-Output $Response.GalaxyCluster
    }

  }

  End {

  }

}