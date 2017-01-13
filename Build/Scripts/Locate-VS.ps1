Param(
  [string] $locateVsApiVersion = "1.0.0",
  [string] $locateVsApiFrameworkShortName = "net45"
)
$ErrorActionPreference="Stop"

function Create-Directory([string[]] $path) {
  if (!(Test-Path -path $path)) {
    New-Item -path $path -force -itemType "Directory" | Out-Null
  }
}

function Locate-LocateVsApi {
  $packagesPath = Locate-PackagesPath
  $locateVsApi = Join-Path -path $packagesPath -ChildPath "ollon.visualstudio.setup.configuration\$locateVsApiVersion\lib\$locateVsApiFrameworkShortName\Ollon.VisualStudio.Setup.Configuration.dll"

  if (!(Test-Path -path $locateVsApi)) {
    throw "The specified LocateVS API version ($locateVsApiVersion) could not be located."
  }

  return Resolve-Path -path $locateVsApi
}

function Locate-PackagesPath {
  if ($env:NUGET_PACKAGES -eq $null) {
    $env:NUGET_PACKAGES =  Join-Path -path $env:UserProfile -childPath ".nuget\packages\"
  }

  $packagesPath = $env:NUGET_PACKAGES

  Create-Directory -path $packagesPath
  return Resolve-Path -path $packagesPath
}

try
{
  $locateVsApi = Locate-LocateVsApi

  Add-Type -path $locateVsApi
  $visualStudioInstallationPath = [SetupEnvironment]::GetSetupInstance().InstallationPath

  return Join-Path -Path $visualStudioInstallationPath -ChildPath "Common7\Tools\"
}
catch
{
  Write-Error $_.Exception.Message
  # Return an empty string and let the caller fallback or handle this as appropriate
  return ""
}
