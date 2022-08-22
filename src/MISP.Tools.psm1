## Running A Build Will Compile This To A Single PSM1 File Containing All Module Code ##

## If Importing Module Source Directly, This Will Dynamically Build Root Module ##

# Get list of private functions and public functions to import, in order.
$PrivateFunctions = @(Get-ChildItem -Path $PSScriptRoot\private -Recurse -Filter "*.ps1") | Sort-Object Name
$PublicFunctions = @(Get-ChildItem -Path $PSScriptRoot\public -Recurse -Filter "*.ps1") | Sort-Object Name

$ModuleName = 'MISP.Tools'

$DefaultMispPreferencePath = Join-Path -Path ([System.Environment]::GetFolderPath('LocalApplicationData')) -ChildPath $ModuleName
$DefaultMispPreferenceFilename = 'MISPContext.xml'

Write-Verbose "Default Preference Path: $($DefaultMispPreferencePath); Default Preference Filename: $($DefaultMispPreferenceFilename)"

# Dot source the private function files.
foreach ($ImportItem in $PrivateFunctions) {
  try {
    . $ImportItem.FullName
    Write-Verbose -Message ("Imported private function {0}" -f $ImportItem.FullName)
  }
  catch {
    Write-Error -Message ("Failed to import private function {0}: {1}" -f $ImportItem.FullName, $_)
  }
}

# Dot source the public function files.
foreach ($ImportItem in $PublicFunctions) {
  try {
    . $ImportItem.FullName
    Write-Verbose -Message ("Imported public function {0}" -f $ImportItem.FullName)
  }
  catch {
    Write-Error -Message ("Failed to import public function {0}: {1}" -f $ImportItem.FullName, $_)
  }
}

# Export the public functions.
Export-ModuleMember -Function $PublicFunctions.BaseName
Export-ModuleMember -Variable DefaultMispPreferenceFilename, DefaultMispPreferencePath
