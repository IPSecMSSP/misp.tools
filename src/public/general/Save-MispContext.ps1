# Save MISP API Key/URI to Configuration File
function Save-MispContext {
    <#
    .SYNOPSIS
        Write MISP Context containing Api Key/URL out to a file for future reference
    .DESCRIPTION
        Write MISP Context containing Api Key/Url out to a file for future reference

        Default location is user's profile path, but can be overridden with -DestinationPath
        Default Filename is MISPContext.xml, but can be overridden with -Filename
    .PARAMETER DestinationPath
        Path to save MispContext to, defaults to users AppDataLocal Path on your operating system
    .PARAMETER FileName
        Name of file to use for MISP Context, defaults to MISPContext.xml
    .INPUTS
        [PSCustomObject]  -> MISP Context
        [String]          -> DestinationPath
        [String]          -> Filename
    .OUTPUTS
        No output is expected if this succeeds
    .EXAMPLE
        Save to default location and filename
        PS > $MispContext | Save-MispContext
    .EXAMPLE
        Save to default location with alternate filename
        PS > $MispContext | Save-MispContext -Filename 'MyMISP.xml'
    .LINK
        https://url.to.repo/repo/path/
    #>

  [CmdletBinding(SupportsShouldProcess)]


  Param (
    [Parameter(
      Mandatory = $true,
      ValueFromPipeline = $true,
      Position = 0
    )]
    [pscustomobject] $InputObject,
    [Parameter(
      Mandatory = $false,
      ValueFromPipeline = $false,
      Position = 1
    )]
    [string] $DestinationPath = $DefaultMispPreferencePath,
    [Parameter(
      Mandatory = $false,
      ValueFromPipeline = $false,
      Position = 2
    )]
    [string] $Filename = $DefaultMispPreferenceFilename
  )

  Begin {
    $Me = $MyInvocation.MyCommand.Name

    $ContextFilename = Join-Path -Path $DestinationPath -ChildPath $Filename
    Write-Verbose "$($Me): Saving MISP Context to $($ContextFilename)"

  }

  Process {
    # Create the folder if it does not exist
    if (!(Test-Path $DestinationPath)) {
      if ($PSCmdlet.ShouldProcess($DestinationPath, "Create Configuration Folder")) {
        Write-Verbose "$($me): Configration Folder $($DestinationPath) does not exist, Creating"
        $Output = New-Item -ItemType Directory -Path $DestinationPath
        Write-Debug $Output
      }
    }

    # Save the file
    if ($PSCmdlet.ShouldProcess($ContextFilename, "Save MISP Context")) {
      Write-Verbose "$($Me): Saving MISP Context to $($ContextFilename)"
      # Ensure output is appropriately formatted
      $OutputObject = [PSCustomObject]@{
        Credential = $InputObject.Credential
        BaseUri = $InputObject.BaseUri.ToString()
        NoValidateSsl = [bool]$InputObject.NoValidateSsl
      }
      $OutputObject | Export-Clixml $ContextFilename
    }
  }

  End {

  }

}