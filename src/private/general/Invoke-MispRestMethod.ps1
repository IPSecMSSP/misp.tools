# Private Function Example - Replace With Your Function
function Invoke-MispRestMethod {

    <#
    .SYNOPSIS
        Invoke a call to the MISP REST API
    .DESCRIPTION
        Invoke a call to the MISP REST API

        This function is intended to abstract the call to Invoke-RestMethod and supply the required details for a MISP call
    .PARAMETER Context
        PSCustomObject with containing the MISP Context
    .PARAMETER Method
        Base API URL for the API Calls to MISP
    .PARAMETER NoValidateSsl
        Don't validate the SSL Certificate
    .INPUTS
        [PSCredential]        -> Credential
        [System.Uri.Builder]  -> BaseUri
        [Switch]              -> NoValidateSsl
        [string]              -> Method (Post, Get, Put, Delete)
    .OUTPUTS
        [PSCustomObject]      -> MISP Context
    .EXAMPLE
        PS> $MispContext = New-MispContext -Credential (Get-Credential -Username 'MISP Api Key') -BaseUri 'https://misp.domain.com'
    .LINK
        https://github.com/IPSecMSSP/misp.tools
    #>

    [CmdletBinding()]

  param(
    [Parameter(Mandatory=$true,
      HelpMessage = 'MISP Context to use. A MISP Context includes both the BaseUri as well as the API Key')]
		[PSCustomObject] $Context,

    [Parameter(Mandatory=$true,
      HelpMessage = 'Full URI to requested REST Resource as String or UriBuilder object')]
    [ValidateScript({
      $TypeName = $_ | Get-Member | Select-Object -ExpandProperty TypeName -Unique
      if ($TypeName -eq 'System.String' -or $TypeName -eq 'System.UriBuilder') {
        [System.UriBuilder]$_
      }
    })]
    [System.UriBuilder]$Uri,

    [Parameter(Mandatory=$false,
      HelpMessage = 'Method to use when making the request. Defaults to GET')]
    [ValidateSet("Post","Get","Put","Delete")]
    [string] $Method = "GET",

    [Parameter(Mandatory=$false,
      HelpMessage = 'PsCustomObject containing data that will be sent as the Json Body')]
    [PsCustomObject] $Body
	)

  Begin {
    $Me = $MyInvocation.MyCommand.Name
    Write-Verbose "$($Me): Invoking MISP REST API with URI $($Uri)"

    $Headers = @{
      "Content-Type" = "application/json"
      "Accept" = "application/json"
      "Authorization" = $Context.Credential.GetNetworkCredential().Password
    }

  }

  Process {

    # Set SSL Preferences/Certificate Trust Policy
    Enable-TrustAllCertsPolicy -NoValidateSsl:$Context.NoValidateSsl

    # Build list of parameters to pass to Invoke-RestMethod
    $Request = @{
      Method = $Method
      Uri = $Uri.ToString()
      Headers = $Headers
    }

    # Add body if supplied
    if ($MyInvocation.BoundParameters.ContainsKey("Body")) {
      $Request.Add('Body', ($Body | ConvertTo-Json -Depth 10))
      # $Request.Add('Body', $Body)
    }

    # There's some altered handling of "Content-Type" Header in some PowerShell 7.2 releases where ContentType Parameter has to be passed instead or in addition
    if (($PSVersionTable.PSVersion.Major -eq 7 -and $PSVersionTable.PSVersion.Minor -ge 2) -or ($PSVersionTable.PSVersion.Major -ge 8)) {
      $Request.Add("ContentType", "application/json")
    }

    $Response = Invoke-RestMethod @Request

    Write-Output $Response

  }

  End {

  }

}