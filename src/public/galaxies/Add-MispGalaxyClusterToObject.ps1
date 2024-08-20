function Add-MispGalaxyClusterToObject {
  <#
    .SYNOPSIS
        Add one or more MISP Galaxy Clusters to an Object
    .DESCRIPTION
        Add one or more MISP Galaxy Clusters to an Object

        Add the Galaxy Clusters to the object specified by Object Type and Id.
    .PARAMETER Context
        PSCustomObject with containing the MISP Context
    .PARAMETER ObjectType
        Type of MISP object to add attributes to. One of 'event', 'attribute', 'tag_collection'
    .PARAMETER ObjectId
        Id of MISP object to add attributes to
    .PARAMETER Id
        Array of Galaxy Cluster Ids to attach to the specified object/type

        You will need to ascertain appropriate galaxy cluster Ids using Get-MispGalaxyCluster.
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
    [ValidateSet('event','attribute','tag_collection')]
    [string]$ObjectType,

    [Parameter(Mandatory = $true)]
    [int]$ObjectId,

    [Parameter(Mandatory = $false)]
    [array] $Id,

    [Parameter(Mandatory = $false)]
    [bool] $Local = $false
  )

  Begin {
    $Me = $MyInvocation.MyCommand.Name

    Write-Verbose "$($Me): Add Galaxy Cluster to MISP Object"

    # If we don't "Clone" the UriBuilder object from the Context, the Context's instance of the BaseUri gets updated. We do not want that.
    $Uri = [System.UriBuilder]$Context.BaseUri.ToString()
    $Uri.Path = [io.path]::combine($Uri.Path, "galaxies/attachCluster", $ObjectId, ("local:{0}" -f $local))

  }

  Process {

    if ($PSCmdlet.ShouldProcess(("Object Type: {0}, ObjectId: {1}" -f $ObjectType, $ObjectId), ("Add Galaxy Cluster {0}" -f $Id))) {
      foreach ($Entry in $Id) {
        Write-Verbose ('{0}: Adding Galaxy Cluster {1} to ObjectId {2}, Type {3}' -f $Me, $Entry, $ObjectId, $ObjectType)

        $Body = @{
          Galaxy = @{
            target_id = $Entry
          }
        }

        Write-Debug ($Body)


        # Add each Galaxy Cluster to the Object in turn
        $Resp = Invoke-MispRestMethod -Context $Context -Uri $Uri -Method POST -Body $Body

        if ($Resp.saved) {
          Write-Verbose ('{0}: Added Galaxy Cluster {1}' -f $Me, $Resp.success)
        } else {
          Write-Verbose ('{0}: Failed to add Galaxy Cluster: {1}' -f $Me, $Resp.message)
        }
      }

    }

  }

  End {

  }

}