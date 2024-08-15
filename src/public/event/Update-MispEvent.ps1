# Set MISP API Key/URI Context
function Update-MispEvent {
  <#
    .SYNOPSIS
        Create a new MISP Event
    .DESCRIPTION
        Create a new MISP Event

        Take the provided details and use these to create a new Event in MISP
    .PARAMETER Context
        PSCustomObject with containing the MISP Context
    .PARAMETER Id
        Id of MISP event to update
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
    [int]$Id,

    [Parameter(Mandatory = $false)]
    [string]$Info,

    [Parameter(Mandatory = $false)]
    [ValidateSet("High", "Medium", "Low", "Undefined")]
    [string]$ThreatLevel,

    [Parameter(Mandatory = $false)]
    [ValidateSet("Initial", "Ongoing", "Complete")]
    [string]$Analysis = "Initial",

    [Parameter(Mandatory = $false)]
    [ValidateSet("Organisation", "Community", "Connected", "All", "Group", "Inherit")]
    [string]$Distribution = "Organisation",

    [Parameter(Mandatory = $false)]
    [System.Boolean]$Published = $false
  )

  Begin {
    $Me = $MyInvocation.MyCommand.Name

    Write-Verbose "$($Me): UPdate MISP Event"

    # If we don't "Clone" the UriBuilder object from the Context, the Context's instance of the BaseUri gets updated. We do not want that.
    $Uri = [System.UriBuilder]$Context.BaseUri.ToString()
    $Uri.Path = [io.path]::combine($Uri.Path, "events/edit")

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
      Community    = 1      # This community only
      Connected    = 2      # Connected Communities
      All          = 3      # All communities
      Group        = 4      # Sharing Group
      Inherit      = 5      # Inherit Event
    }
  }

  Process {
    # Create a new UriBuilder object for each event
    $EventUri = [System.UriBuilder]$Uri.Uri.ToString()
    $EventUri.Path = [io.path]::combine($EventUri.Path, $Id)


    # Build up the Event Body
    $EventBody = [pscustomobject]@{}

    if ($PSBoundParameters.ContainsKey('Info')) {
      $EventBody | Add-Member -MemberType NoteProperty -Name 'info' -Value $Info
    }

    if ($PSBoundParameters.ContainsKey('ThreatLevel')) {
      $EventBody | Add-Member -MemberType NoteProperty -Name 'threat_level_id' -Value $ThreatLevelMap.($ThreatLevel)
    }

    if ($PSBoundParameters.ContainsKey('Analysis')) {
      $EventBody | Add-Member -MemberType NoteProperty -Name 'analysis' -Value $AnalysisMap.($Analysis)
    }

    if ($PSBoundParameters.ContainsKey('Distribution')) {
      $EventBody | Add-Member -MemberType NoteProperty -Name 'distribution' -Value $DistributionMap.($Distribution)
    }

    if ($PSBoundParameters.ContainsKey('Published')) {
      $EventBody | Add-Member -MemberType NoteProperty -Name 'published' -Value $Published
    }

    Write-Debug "Event Body:`n$($EventBody | ConvertTo-Json -Depth 10)"

    If ($PSCmdlet.ShouldProcess("Update MISP Event")) {
      # Call the API
      #Write-Output $EventBody | ConvertTo-Json -depth 10
      $Response = Invoke-MispRestMethod -Context $Context -Uri $EventUri -Method "PUT" -Body $EventBody
    }

    Write-Output $Response.Event

  }

  End {

  }

}