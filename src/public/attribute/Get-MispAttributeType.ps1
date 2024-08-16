function Get-MispAttributeType {
  <#
    .SYNOPSIS
      Retrieve available Attribute Type information from MISP Instance
    .DESCRIPTION
      Get the available Attribute Types, Categories, Sane Defaults and Category to Type mappings
    .PARAMETER Context
      PSCustomObject with containing the MISP Context
    .INPUTS
      [PsCustomObject]    -> Context
    .OUTPUTS
      [PSCustomObject]
        - types
        - categories
        - category_type_mappings
        - sane_defaults
  #>
  [CmdLetBinding()]
  param (
    [Parameter(Mandatory = $true)]
    [PsCustomObject]$Context
  )


  Begin {
    $Me = $MyInvocation.MyCommand.Name
    Write-Verbose ('{0}: Fetch list of Available Attribute Types' -f $Me)

    # If we don't "Clone" the UriBuilder object from the Context, the Context's instance of the BaseUri gets updated. We do not want that.
    $Uri = [System.UriBuilder]$Context.BaseUri.ToString()
    $Uri.Path = [io.path]::combine($Uri.Path, "attributes/describeTypes")
  }

  Process {
    $Response = Invoke-MispRestMethod -Context $Context -Method GET -Uri $Uri.Uri.ToString()

    Write-Output $Response.result
  }
}