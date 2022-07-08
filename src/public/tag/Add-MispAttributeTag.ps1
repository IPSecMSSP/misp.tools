# Set MISP API Key/URI Context
function Add-MispAttributeTag {
  <#
  .SYNOPSIS
      Add a tag to a MISP Attribute
  .DESCRIPTION
      Add a tag to a MISP Attribute

      An attribute may have one or more tags associated.  This can assist with the filtering and grouping of attributes
  .PARAMETER Context
      PSCustomObject with containing the MISP Context
  .PARAMETER TagId
      Id of tag to add to Attribute
  .PARAMETER EventId
      Id of Attribute to which tag should be added
  .PARAMETER Local
      Whether the tag should be attached locally or not to the event
  .INPUTS
      [PsCustomObject]    -> Context
      [Int]               -> TagId
      [Int]               -> AttributeId
      [switch]            -> Local
  .OUTPUTS
      None if successful
  .EXAMPLE
      PS> $Tags = Add-MispAttributeTag -Context $MispContext -AttributeId 1234 -TagId 69 -Local
      Add Tag with Id 69 to attribute Id 1234, locally
  .LINK
      https://url.to.repo/repo/path/
      https://www.circl.lu/doc/misp/automation/#attribute-management
  #>

[CmdletBinding()]

param (
  [Parameter(Mandatory=$true)]
  [PsCustomObject]$Context,

  [Parameter(
    Mandatory=$true
    )]
  [Int]$AttributeId,

  [Parameter(
    Mandatory=$true
    )]
  [Int]$TagId,

  [Parameter(
    Mandatory=$false
  )]
  [switch] $Local
)

Begin {
  $Me = $MyInvocation.MyCommand.Name

  Write-Verbose "$($Me): Add Tag to MISP Attribute"

  if($Local) {
    $TagLocal = 1
  } else {
    $TagLocal = 0
  }

  # If we don't "Clone" the UriBuilder object from the Context, the Context's instance of the BaseUri gets updated. We do not want that.
  $Uri = [System.UriBuilder]$Context.BaseUri.ToString()
  $Uri.Path = [io.path]::combine($Uri.Path, ("attributes/addTag/{0}/{1}/local:{2}" -f $AttributeId, $TagId, $TagLocal))

}

Process {

  # Call the API
  $Response = Invoke-MispRestMethod -Context $Context -Uri $Uri -Method 'POST'

  Write-Debug $Response | ConvertTo-Json -Depth 10
  if (!$Response.saved) {
    Write-Warning "Unable to add tag to Attribute"
  }
}

End {

}

}