# Set MISP API Key/URI Context
function Get-MispGalaxy {
  <#
    .SYNOPSIS
        Get MISP Galax(y/ies)
    .DESCRIPTION
        Get MISP Galax(y/ies)

        If no Galaxy ID is supplied, all galaxies are returned
    .PARAMETER Context
        PSCustomObject with containing the MISP Context
    .PARAMETER Id
        Id of a specific galaxy
    .PARAMETER Criteria
        Search criteria to match. eg. "banana"
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
        PS> $Event = Get-MispGalaxy -Context $MispContext -Criteria 'banana'
        Return all galaxies containing the text 'banana'
    .LINK
        https://github.com/IPSecMSSP/misp.tools
        https://www.circl.lu/doc/misp/automation/#attribute-management
    #>

  [CmdletBinding(DefaultParameterSetName = 'ListAll')]

  param (
    [Parameter(Mandatory = $true)]
    [PsCustomObject]$Context,

    [Parameter(
      Mandatory = $false,
      ParameterSetName = 'ById'
    )]
    [Int]$Id,

    [Parameter(
      Mandatory = $false,
      ParameterSetName = 'ByCriteria'
    )]
    [string]$Criteria
  )

  Begin {
    $Me = $MyInvocation.MyCommand.Name

    Write-Verbose "$($Me): Get MISP Galax(y/ies)"

    # Default Method
    $Method = 'GET'

    # If we don't "Clone" the UriBuilder object from the Context, the Context's instance of the BaseUri gets updated. We do not want that.
    $Uri = [System.UriBuilder]$Context.BaseUri.ToString()
    $Uri.Path = [io.path]::combine($Uri.Path, "galaxies")

    # Append the Event Id if requested
    if ($MyInvocation.BoundParameters.ContainsKey("Id")) {
      $Uri.Path = [io.path]::combine($Uri.Path, "view/$($Id)")
    }
    elseif ($PSCmdlet.ParameterSetName -eq 'ByCriteria') {
      $Method = 'POST'
      $SearchBody = @{
        value = $Criteria
      }
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
      # Only a single galaxy was requested
      Write-Output $Response
    }
    elseif ($PSCmdlet.ParameterSetName -eq 'ByCriteria') {
      Write-Output $Response.Galaxy
    }
    else {
      # Return all fo the galaxies
      Write-Output $Response.Galaxy
    }

  }

  End {

  }

}