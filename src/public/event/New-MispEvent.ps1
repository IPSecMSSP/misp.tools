# Set MISP API Key/URI Context
function New-MispEvent {
  <#
    .SYNOPSIS
        Create a new MISP Event
    .DESCRIPTION
        Create a new MISP Event

        Take the provided details and use these to create a new Event in MISP
    .PARAMETER Context
        PSCustomObject with containing the MISP Context
    .PARAMETER Info
        Name/Description of the Event
    .PARAMETER ThreatLevel
        Threat Level of the event. One of [High, Medium, Low, Undefined]
    .PARAMETER Analysis
        Analysis State for the Event. One of [Initial, Ongoing, Complete]. Defaults to 'Initial'
    .PARAMETER Distribution
        Distribution Level for the Event. One of [Organisation, Community, Connected, All, Group, Inherit]. Defaults to 'Organisation'
    .PARAMETER Published
        Boolean value as to whether the event should be published. Defaults to false.
    .PARAMETER Attribute
        Array of Attributes to attach ot the event. Each attribute consist of a Value and Type at minimum, and may include IPs, hostnames, file hashes, etc.
    .PARAMETER Organisation
        Name or Id of organisation to associate the event to. This will be uses as the "Creator Organisation".

        If not specified, will use the Organisation of the User creating the Event.

        The Owner Organisation is always the Organisation of the user creating the event.
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
    [string]$Info,

    [Parameter(Mandatory = $false)]
    [ValidateSet("High", "Medium", "Low", "Undefined")]
    [string]$ThreatLevel = "Undefined",

    [Parameter(Mandatory = $false)]
    [ValidateSet("Initial", "Ongoing", "Complete")]
    [string]$Analysis = "Initial",

    [Parameter(Mandatory = $false)]
    [ValidateSet("Organisation", "Community", "Connected", "All", "Group", "Inherit")]
    [string]$Distribution = "Organisation",

    [Parameter(Mandatory = $false)]
    [System.Boolean]$Published = $false,

    [Parameter(Mandatory = $false)]
    [array] $Attribute,

    [Parameter(Mandatory = $false)]
    [string]$Organisation
  )

  Begin {
    $Me = $MyInvocation.MyCommand.Name

    Write-Verbose "$($Me): Create new MISP Event(s)"

    # If we don't "Clone" the UriBuilder object from the Context, the Context's instance of the BaseUri gets updated. We do not want that.
    $Uri = [System.UriBuilder]$Context.BaseUri.ToString()
    $Uri.Path = [io.path]::combine($Uri.Path, "events")

    $ThreatLevelMap = @{
      High      = 1
      Medium    = 2
      Low       = 3
      Undefined = 4
    }

    $AnalysisMap = @{
      Initial  = 0
      Ongoing  = 1
      Complete = 2
    }

    $DistributionMap = @{
      Organisation = 0      # Your organisation only
      Community    = 1         # This community only
      Connected    = 2         # Connected Communities
      All          = 3               # All communities
      Group        = 4             # Sharing Group
      Inherit      = 5           # Inherit Event
    }
  }

  Process {

    # Build up the Event Body
    $EventBody = [pscustomobject]@{
      date            = (Get-Date).ToString("yyyy-MM-dd")
      threat_level_id = $ThreatLevelMap.($ThreatLevel)
      info            = $Info
      published       = $Published
      analysis        = $AnalysisMap.($Analysis)
      distribution    = $DistributionMap.($Distribution)
    }

    if ($PSBoundParameters.ContainsKey('Organisation')) {
      # Check if the organisation is an Integer or something else
      $OrganisationId = 0
      if ([int]::TryParse($Organisation, [ref]$OrganisationId)) {
        # Integer ID, check for existence
        $Org = Get-MispOrganisation -Context $Context -Id $OrganisationId
        if (-not $Org) {
          throw ('Organisation does not exist in MISP: {0}' -f $Organisation)
        }
      }
      elseif ($Organisation -match '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$') {
        # Id is a UUID
        $Org = Get-MispOrganisation -Context $Context -Id $Organisation
        if (-not $Org) {
          throw ('Organisation does not exist in MISP: {0}' -f $Organisation)
        }
      }
      else {
        # Not an integer, try a name match
        $Org = Get-MispOrganisation -Context $Context -Name $Organisation
        if (-not $Org) {
          Write-Verbose ('Organisation Name not found in MISP: {0}' -f $Organisation)
          $Org = New-MispOrganisation -Context $Context -Name $Organisation
        }
      }
      # When setting the Creator Org for an event, the back-end checks the value of orgc.uuid, so pass the whole Org object
      $EventBody | Add-Member -MemberType NoteProperty -Name 'orgc' -Value $Org
    }

    # If attributes were supplied, add these too
    if ($MyInvocation.BoundParameters.ContainsKey("Attribute")) {
      $EventBody | Add-Member -MemberType NoteProperty -Name 'Attribute' -Value $Attribute
    }

    Write-Debug "Event Body:`n$($EventBody | ConvertTo-Json -Depth 10)"

    If ($PSCmdlet.ShouldProcess("Create new MISP Event")) {
      # Call the API
      #Write-Output $EventBody | ConvertTo-Json -depth 10
      $Response = Invoke-MispRestMethod -Context $Context -Uri $Uri -Method "POST" -Body $EventBody
    }

    Write-Output $Response.Event

  }

  End {

  }

}