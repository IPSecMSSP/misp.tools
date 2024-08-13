function Update-MispOrganisation {
  <#
    .SYNOPSIS
        Create a new MISP Event
    .DESCRIPTION
        Create a new MISP Event

        Take the provided details and use these to create a new Event in MISP
    .PARAMETER Context
        PSCustomObject with containing the MISP Context
    .PARAMETER Id
        Id of Organisation to update.
    .PARAMETER Name
        New Name of the organisation.
    .PARAMETER Uuid
        New UUID to assign to Organisation. If not specified, a new UUID will be generated automatically.
    .PARAMETER Description
        More detailed description of the Organisation.
    .PARAMETER Nationality
        Nationality of the Organisation, if applicable/known.
    .PARAMETER Sector
        Industry Sector of the Organisation. Sectors defined as per https://github.com/MISP/misp-galaxy/blob/main/clusters/sector.json
    .PARAMETER LocalOrg
        Boolean value indicating whether this is a local organisation. Defaults to true.
    .PARAMETER RestrictDomains
        Array of domains to restrict users to. Users that are part of the listed domains will be associated with this org.
    .PARAMETER LandingPage
        URL to Landing Page for Org.
    .PARAMETER Type
        Organisation Type. Freeform text.
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
        https://www.misp-project.org/openapi/#tag/Organisations
    #>  [cmdletbinding(SupportsShouldProcess)]
  param (
    [Parameter(Mandatory = $true)]
    [PsCustomObject]$Context,

    [Parameter(Mandatory = $true)]
    [string]$Id,

    [Parameter(Mandatory = $false)]
    [string]$Name,

    [Parameter(Mandatory = $false)]
    [string]$Description,

    [Parameter(Mandatory = $false)]
    [string]$Type,

    [Parameter(Mandatory = $false)]
    [string]$Nationality,

    [Parameter(Mandatory = $false)]
    [string]$Sector,

    [Parameter(Mandatory = $false)]
    [boolean]$LocalOrg = $true,

    [Parameter(Mandatory = $false)]
    [array]$RestrictDomains,

    [Parameter(Mandatory = $false)]
    [string]$LandingPage

  )

  Begin {
    $Me = $MyInvocation.MyCommand.Name
    Write-Verbose ('Entering: {0}' -f $Me)

    # If we don't "Clone" the UriBuilder object from the Context, the Context's instance of the BaseUri gets updated. We do not want that.
    $Uri = [System.UriBuilder]$Context.BaseUri.ToString()
    $Uri.Path = [io.path]::combine($Uri.Path, 'admin', 'organisations', 'edit')
  }

  Process {
    $Uri.Path = [io.path]::combine($Uri.Path, $Id)

    $Organisation = @{}

    if ($PSBoundParameters.ContainsKey('Name')) {
      Write-Verbose ('{0}: Adding parameter [name]: {1}' -f $Me, $Name)
      $Organisation.Add('name', $Name)
    }

    if ($PSBoundParameters.ContainsKey('Description')) {
      $Organisation.Add('descriptiopn',$Description)
    }

    if ($PSBoundParameters.ContainsKey('Uuid')) {
      $Organisation.Add('uuid', $Uuid)
    }

    if ($PSBoundParameters.ContainsKey('Type')) {
      $Organisation.Add('type', $Type)
    }

    if ($PSBoundParameters.ContainsKey('Sector')) {
      $Organisation.Add('sector', $Sector)
    }

    if ($PSBoundParameters.ContainsKey('Nationality')) {
      $Organisation.Add('nationality', $Nationality)
    }

    if ($PSBoundParameters.ContainsKey('RestrictDomains')) {
      $Organisation.Add('restricted_to_domain', $RestrictDomains)
    }

    if ($PSBoundParameters.ContainsKey('LocalOrg')) {
      $Organisation.Add('local', $LocalOrg)
    }

    Write-Debug ('{0}: Payload: {1}' -f $Me, $EventBody)

    if ($PSCmdlet.ShouldProcess($Uri.Uri.ToString(), 'Update MISP Organisation')) {
      # Call the API
      $Response = Invoke-MispRestMethod -Context $Context -Uri $Uri -Method "PUT" -Body $Organisation
    }

    Write-Output $Response
  }

  End {

  }
}