function Get-MispOrganisation {
  <#
    .SYNOPSIS
        Get MISP Organisation Details
    .DESCRIPTION
        Get MISP Organisation Details, either by Id, Name, or all

        Take the provided details and use these to create a new Organisation in MISP
    .PARAMETER Context
        PSCustomObject with containing the MISP Context
    .PARAMETER Name
        Name of the organisation to return detais for.
    .PARAMETER Id
        Id of Organisation to return details for.
    .INPUTS
        [PsCustomObject]    -> Context
        [Int]               -> Id
        [string]            -> Name
    .OUTPUTS
        [Array]             -> Array of Organisations
    .EXAMPLE
        PS> $Org = Get-MispOrganisation -Context $MispContext -Name 'My Organisation'
        Returns definition of 'My Organisation', or $Null if it does not exist
    .EXAMPLE
        PS> $Org = Get-MispOrganisation -Context $MispContext -Id 7
        Returns definition of the organisation with Id 7, or $Null if it does not exist
    .LINK
        https://github.com/IPSecMSSP/misp.tools
        https://www.misp-project.org/openapi/#tag/Organisations
    #>
  [cmdletbinding(DefaultParameterSetName = 'All')]
  param (
    [Parameter(Mandatory = $true)]
    [PsCustomObject]$Context,

    [Parameter(Mandatory = $true,ParameterSetName = 'ByName')]
    [string]$Name,

    [Parameter(Mandatory = $true, ParameterSetName = 'ById')]
    [string]$Id
  )

  Begin {
    $Me = $MyInvocation.MyCommand.Name
    Write-Verbose ('Entering: {0}' -f $Me)

    # If we don't "Clone" the UriBuilder object from the Context, the Context's instance of the BaseUri gets updated. We do not want that.
    $Uri = [System.UriBuilder]$Context.BaseUri.ToString()
    $Uri.Path = [io.path]::combine($Uri.Path, 'organisations')
  }

  Process {

    switch ($PsCmdLet.ParameterSetName) {
      'ById' {
        # Append the Org ID to the URI Path
        $Uri.Path = [io.path]::combine($Uri.Path, 'view', $Id)

        $Organisation = (Invoke-MispRestMethod -Context $Context -Uri $Uri -Method "GET").Organisation
      }

      'ByName' {
        # Get all orgs
        $Orgs = Invoke-MispRestMethod -Context $Context -Uri $Uri -Method "GET"

        # Filter to the matching Org
        $Organisation = $Orgs.Organisation | Where-Object -Property name -eq $Name
      }

      'All' {
        # Get all orgs
        $Organisation = (Invoke-MispRestMethod -Context $Context -Uri $Uri -Method "GET").Organisation
      }
    }

    # Output Organisation(s)
    Write-Output $Organisation

  }

  End {

  }
}