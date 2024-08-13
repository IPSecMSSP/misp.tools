function New-MispOrganisation {
  <#
    .SYNOPSIS
        Create a new MISP Organisation
    .DESCRIPTION
        Create a new MISP Organisation

        Take the provided details and use these to create a new Organisation in MISP
    .PARAMETER Context
        PSCustomObject with containing the MISP Context
    .PARAMETER Name
        Name of the organisation.
    .PARAMETER Uuid
        Specific UUID to assign to Organisation. If not specified, a new UUID will be generated automatically.
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
        [String]            -> Name
        [string]            -> Uuid
        [string]            -> Description
        [string]            -> Nationality
        [string]            -> Sector
        [boolean]           -> LocalOrg
        [array][string]     -> RestrictDomains
        [string]            -> LandingPage
        [string]            -> Type
    .OUTPUTS
        [PsCustomObject]    -> Properties of New Organisation
    .EXAMPLE
        PS> $Org = New-MispOrganisation -Context $MispContext -Name 'My Organisation'
        Returns definition of new organisation
    .EXAMPLE
        PS> $Org = New-MispOrganisation -Context $MispContext -Name 'My Organisation' -UUID '63f6c8c0-2563-4b3b-bc46-64b3016f9948' -Local $False
        Create a new remote organisation with the specified UUID (to match a definition elsewhere)
        Returns definition of the new organisation
    .LINK
        https://github.com/IPSecMSSP/misp.tools
        https://www.misp-project.org/openapi/#tag/Organisations
    #>  [cmdletbinding(SupportsShouldProcess)]
  param (
    [Parameter(Mandatory = $true)]
    [PsCustomObject]$Context,

    [Parameter(Mandatory = $true)]
    [string]$Name,

    [Parameter(Mandatory = $false)]
    [string]$Uuid,

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
    $Uri.Path = [io.path]::combine($Uri.Path, 'admin','organisations', 'add')
  }

  Process {

    $Organisation = @{
      name = $Name
      description = $Description
      type = $Type
      sector = $Sector
      uuid = $Uuid
      nationality = $Nationality
      restricted_to_domain = $RestrictDomains
      landingpage = $LandingPage
      local = $LocalOrg
    }

    if ($PSCmdlet.ShouldProcess($Uri.Uri.ToString(), 'Create new MISP Organisation')) {
      # Call the API
      $Response = Invoke-MispRestMethod -Context $Context -Uri $Uri -Method "POST" -Body $Organisation
    }

    Write-Output $Response.Organisation
  }

  End {

  }
}