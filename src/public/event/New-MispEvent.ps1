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
    .PARAMETER Event
        Id of a specific event
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
        https://url.to.repo/repo/path/
        https://www.circl.lu/doc/misp/automation/#events-management
    #>

  [CmdletBinding()]

  param (
    [Parameter(Mandatory=$true)]
    [PsCustomObject]$Context,

    [Parameter(Mandatory=$true)]
    [string]$Info,

    [Parameter(Mandatory=$true)]
    [ValidateSet("High","Medium","Low","Undefined")]
    [string]$ThreatLevel,

    [Parameter(Mandatory=$false)]
    [ValidateSet("Initial","Ongoing","Complete")]
    [string]$Analysis = "Initial",

    [Parameter(Mandatory=$false)]
    [ValidateSet("Organisation","Community","Connected","All","Group","Inherit")]
    [string]$Distribution = "Organisaton",

    [Parameter(Mandatory=$false)]
    [System.Boolean]$Published = $false,

    [Parameter(Mandatory=$false)]
    [array] $Attribute
    )

  Begin {
    $Me = $MyInvocation.MyCommand.Name

    Write-Verbose "$($Me): Get MISP Event(s)"

    # If we don't "Clone" the UriBuilder object from the Context, the Context's instance of the BaseUri gets updated. We do not want that.
    $Uri = [System.UriBuilder]$Context.BaseUri.ToString()
    $Uri.Path = [io.path]::combine($Uri.Path, "events")

    $ThreatLevelMap = @{
      High = 1
      Medium = 2
      Low = 3
      Undefined = 4
    }

    $AnalysisMap = @{
      Initial = 0
      Ongoing = 1
      Complete = 2
    }

    $DistributionMap = @{
      Organisation = 0      # Your organisation only
      Community = 1         # This community only
      Connected = 2         # Connected Communities
      All = 3               # All communities
      Group = 4             # Sharing Group
      Inherit = 5           # Inherit Event
    }
  }

  Process {

    # Build up the Event Body
    $EventBody = [pscustomobject]@{
      date = (Get-Date).ToString("yyyy-MM-dd")
      threat_level_id = $ThreatLevelMap.($ThreatLevel)
      info = $Info
      published = $Published
      analysis = $AnalysisMap.($Analysis)
      distribution = $DistributionMap.($Distribution)
    }

    # If attributes were supplied, add these too
    if($MyInvocation.BoundParameters.Contains("Attribute")) {
      $EventBody.Add('Attribute', $Attribute)
    }

    # Call the API
    $Response = Invoke-MispRestMethod -Context $Context -Uri $Uri -Method "POST" -Body $EventBody

    Write-Output $Response.Event

  }

  End {

  }

}