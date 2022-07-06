# Set MISP API Key/URI Context
function Get-MispWarningList {
    <#
    .SYNOPSIS
        Get MISP Warning List(s)
    .DESCRIPTION
        Get MISP Warning List(s)

        If no Warning List ID is supplied, all warning lists are returned
    .PARAMETER Context
        PSCustomObject with containing the MISP Context
    .PARAMETER Id
        Id of a specific warning list
    .PARAMETER Criteria
        Criteria to limit the set of returned Warning Lists

        Available Criteria are:
        - enabled
        - category
        - type
    .INPUTS
        [PsCustomObject]    -> Context
        [Int]               -> Id
        [hashtable]         -> Criteria
    .OUTPUTS
        [Array]             -> Array of Warning Lists
    .EXAMPLE
        PS> $WarningLists = Get-MispWarningList -Context $MispContext
        Return first all Warning Lists
    .EXAMPLE
        PS> $WarningLists = Get-MispWarningList -Context $MispContext -Id 1234
        Return details for warning list 1234
    .EXAMPLE
        PS> $Criteria = @{
          enabled = $true
        }
        PS> $WarningLists = Get-MispWarningList -Context $MispContext -Criteria $Criteria
        Return Enabled Warning Lists
    .LINK
        https://url.to.repo/repo/path/
        https://www.circl.lu/doc/misp/automation/#warninglists-api
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
    [hashtable]$Criteria
  )

  Begin {
    $Me = $MyInvocation.MyCommand.Name

    Write-Verbose "$($Me): Get MISP Warning List(s)"

    # If we don't "Clone" the UriBuilder object from the Context, the Context's instance of the BaseUri gets updated. We do not want that.
    $Uri = [System.UriBuilder]$Context.BaseUri.ToString()
    $Uri.Path = [io.path]::combine($Uri.Path, "warninglists")

    # Append the Event Id if requested
    if ($MyInvocation.BoundParameters.ContainsKey("Id")) {
      $Uri.Path = [io.path]::combine($Uri.Path, "view/$($Id)")
    }
  }

  Process {

    Write-Verbose "$($Me): Invoking with ParameterSetName: $($PSCmdlet.ParameterSetName)"
    # Call the API
    if ($PSCmdlet.ParameterSetName -eq 'Criteria') {
      $Response = Invoke-MispRestMethod -Context $Context -Uri $Uri -Method 'POST' -Body $Criteria
    } else {
      $Response = Invoke-MispRestMethod -Context $Context -Uri $Uri
    }

    if ($MyInvocation.BoundParameters.ContainsKey("Id")) {
      # Only a single event was requested
      Write-Output $Response
    } else {
      # Return all fo the events
      Write-Output $Response.WarningLists
    }

  }

  End {

  }

}