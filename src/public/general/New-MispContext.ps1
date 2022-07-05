# Set MISP API Key/URI Context
function New-MispContext {
    <#
    .SYNOPSIS
        Create a PSObject containing Credentials and Base URI for interaction with MISP
    .DESCRIPTION
        Create a PSObject containing Credentials and Base URI for interaction with MISP

        Credentials supplied in the form of a PSCredential Object and Base URI as either a string or Uri::Builder object
    .PARAMETER Credential
        PSCredential Object with ApiKey as Password
    .PARAMETER BaseUri
        Base API URL for the API Calls to MISP
    .PARAMETER NoValidateSsl
        Don't validate the SSL Certificate
    .INPUTS
        [PSCredential]        -> Credential
        [System.Uri.Builder]  -> BaseUri
        [Switch]              -> NoValidateSsl
    .OUTPUTS
        [PSCustomObject]      -> MISP Context
    .EXAMPLE
        PS> $MispContext = New-MispContext -Credential (Get-Credential -Username 'MISP Api Key') -BaseUri 'https://misp.domain.com'
    .LINK
        https://url.to.repo/repo/path/
    #>

  [CmdletBinding()]

  param (
    [Parameter(Mandatory=$true)]
    [pscredential]$Credential,

    [Parameter(Mandatory=$true)]
    [ValidateScript({
      $TypeName = $_ | Get-Member | Select-Object -ExpandProperty TypeName -Unique
      if ($TypeName -eq 'System.String' -or $TypeName -eq 'System.UriBuilder') {
        [System.UriBuilder]$_
      }
    })]
    [System.UriBuilder]$BaseUri,

    [Parameter(Mandatory=$false)]
    [switch]$NoValidateSsl
  )

  Begin {
    $Me = $MyInvocation.MyCommand.Name

    Write-Verbose "$($Me): Setting credentials for MISP with Base URI: $($BaseUri). Cerificiate Validation: $(!$NoValidateSsl)"

    $MispContext = New-Object pscustomobject -Property @{
      Credential = $Credential
      BaseUri = $BaseUri
      NoValidateSsl = [boolean]$NoValidateSsl
    }

  }

  Process {
    # Set SSL Preferences/Certificate Trust Policy
    Enable-TrustAllCertsPolicy
    Write-Output $MispContext

  }

  End {

  }

}