# Set MISP API Key/URI Context
function Search-MispAttribute {
    <#
    .SYNOPSIS
        Search for MISP Event(s)
    .DESCRIPTION
        Search for MISP Event(s)

        If no Event ID is supplied, the first 100 events are returned
    .PARAMETER Context
        PSCustomObject with containing the MISP Context
    .PARAMETER Search
        JSON containing search criteria

        As an example, if we want to export all the IP Addresses that have a TLP marking and not marked as TLP:red, the following filter will achieve this
        $Search = @{
          returnFormat = "json"
          type = @{
            OR = @("ip-src", "ip-dst")
          }
          tags = @{
            NOT = @("tlp:red")
            OR = @("tlp:%")
          }
        }
        Refer to MISP Automation -> Search for further details on available search criteria
    .INPUTS
        [PsCustomObject]    -> Context
        [hastable]          -> Search
    .OUTPUTS
        [Array]             -> Array of Events
    .EXAMPLE
        PS> $Attributes = Search-MispAttribute -Context $MispContext -Search $Search
        Return matching attributes
    .LINK
        https://www.circl.lu/doc/misp/automation/#search
        https://url.to.repo/repo/path/
    #>

  [CmdletBinding(
    SupportsShouldProcess,
    ConfirmImpact="Low"
  )]

  param (
    [Parameter(Mandatory=$true)]
    [PsCustomObject]$Context,

    [Parameter(Mandatory=$true)]
    [string]$Search
    )

  Begin {
    $Me = $MyInvocation.MyCommand.Name

    Write-Verbose "$($Me): Search for MISP Attributes(s)"

    # If we don't "Clone" the UriBuilder object from the Context, the Context's instance of the BaseUri gets updated. We do not want that.
    $Uri = [System.UriBuilder]$Context.BaseUri.ToString()
    $Uri.Path = [io.path]::combine($Uri.Path, "attributes/restSearch")

  }

  Process {

    if ($PSCmdlet.ShouldProcess("Search MISP Attributes")) {
      # Call the API
      $Response = Invoke-MispRestMethod -Context $Context -Uri $Uri -Body $Search -Method 'POST'

      # Return all fo the events
      Write-Output $Response
    }

  }

  End {

  }

}