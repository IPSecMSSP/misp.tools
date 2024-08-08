# Read MISP API Key/URI from configuration file
function Read-MispContext {
    <#
    .SYNOPSIS
        Read the MISP Context from a saved preferences file
    .DESCRIPTION
        Read the MISP Context from a saved preferences file

        Check to see that the contents of the file matches our expectations after loading
    .PARAMETER Path
        Path containing the preferences file, defaults to users AppDataLocal Path
    .PARAMETER FileName
        Name of file to use for MISP Context, defaults to MISPContext.xml
    .INPUTS
        [String]          -> Path
        [String]          -> Filename
    .OUTPUTS
        [PSCustomObject]  -> MISP Context into $MispContext
    .EXAMPLE
        PS > $MispContext = Read-MispContext
    .EXAMPLE
        PS > $MispContext = Read-MispContext -Filename 'MyMISP.xml'
    .LINK
        https://github.com/IPSecMSSP/misp.tools
    #>

  [CmdletBinding()]

  Param (
    [Parameter(
      Mandatory = $false,
      ValueFromPipeline = $false,
      Position = 0
    )]
    [string] $Path = $DefaultMispPreferencePath,
    [Parameter(
      Mandatory = $false,
      ValueFromPipeline = $false,
      Position = 1
    )]
    [string] $Filename = $DefaultMispPreferenceFilename
  )

  Begin {
    $Me = $MyInvocation.MyCommand.Name

    $ContextFilename = Join-Path -Path $Path -ChildPath $Filename
    Write-Verbose "$($Me): Loading MISP Context from $($ContextFilename)"

  }

  Process {
    # Check directory exists
    if (!(Test-Path -Path $Path -PathType Container)) {
      throw "Path not found: $($Path)"
    }

    # Check file exists
    if (!(Test-Path -Path $ContextFilename -PathType Leaf)) {
      throw "Context File not found: $($ContextFilename)"
    }

    # Load file contents
    try {
      $LoadContext = Import-Clixml -Path $ContextFilename
    } catch {
      throw "Error loading context from file $($ContextFilename)"
    }

    $ContextProperties = $LoadContext | Get-Member -MemberType NoteProperty

    # Check if a Credential Property Exists
    If (!($ContextProperties.Name -contains 'Credential')){
      throw "Context File did not contain a Credential Property"
    }

    # Ensure Credential Property is of the correct type
    If (!($LoadContext.Credential.GetType().Name -eq 'PSCredential')) {
      throw "Context File Credential Property is not of type [PSCredential]"
    }

    # Check if a Credential Property Exists
    If (!($ContextProperties.Name -contains 'BaseUri')){
      throw "Context File did not contain a BaseUri Property"
    }

    # Ensure BaseUri Property is of the correct type
    If (!($LoadContext.BaseUri.GetType().Name -eq 'String')) {
      throw "Context File BaseUri Property is not of type [String]"
    }

    # Check if a NoValidateSsl Property Exists
    If (!($ContextProperties.Name -contains 'NoValidateSsl')){
      throw "Context File did not contain a NoValidateSsl Property"
    }

    # Ensure NoValidateSsl Property is of the correct type
    If (!($LoadContext.NoValidateSsl.GetType().Name -eq 'boolean')) {
      throw "Context File NoValidateSsl Property is not of type [boolean]"
    }

    $OutputContext = [PSCustomObject]@{
      Credential = [PSCredential]$LoadContext.Credential
      BaseUri = [System.UriBuilder]$LoadContext.BaseUri
      NoValidateSsl = $LoadContext.NoValidateSsl
    }

    Write-Output $OutputContext

  }

  End {

  }

}