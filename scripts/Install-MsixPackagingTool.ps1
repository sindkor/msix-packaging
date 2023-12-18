param(
    # URL to the MSIX packging tool msixbundle installation file
    [Parameter(Mandatory=$true)]
    [String]
    $MSIXPackagingToolInstallationFileUrl,

    # URL to the MSIX packaging tool license file
    [Parameter(Mandatory=$true)]
    [String]
    $MSIXPackagingToolLicenseFileUrl,

    # Path to temp directory (will be created), defaults to $env:TEMP\MSIX
    [Parameter(Mandatory=$false)]
    [String]
    $TempDirectoryPath = "$env:TEMP\MSIX"
)

if (Test-Path $TempDirectoryPath) {
    Write-Output "Temp directory already exists"
} else {
    Write-Output "Creating temp directory"
    New-Item -ItemType Directory $TempDirectoryPath
}

Write-Output "Downloading MSIX Packaging tool"
Invoke-WebRequest $MSIXPackagingToolInstallationFileUrl -OutFile $TempDirectoryPath\MSIXPackagingTool.msixbundle
Invoke-WebRequest $MSIXPackagingToolLicenseFileUrl -OutFile $TempDirectoryPath\MSIXPackagingToolLicense.xml

Add-AppxProvisionedPackage -Online -PackagePath $TempDirectoryPath\MSIXPackagingTool.msixbundle -LicensePath $TempDirectoryPath\MSIXPackagingToolLicense.xml
Import-Module Appx -UseWindowsPowerShell
$package = Get-AppxPackage -Name "Microsoft.MSIXPackagingTool"
Write-Output "PackageFamilyName is $($package.PackageFamilyName)"
$initalizeMsixPackagingToolCmd = "explorer.exe shell:AppsFolder\$($package.PackageFamilyName)!Msix.app"
Write-Output "Executing $initalizeMsixPackagingToolCmd"
Invoke-Expression $initalizeMsixPackagingToolCmd

Write-Output "Waiting 5 seconds to allow MSIX Tool to initialize"
Start-Sleep 5

Write-Output "Copying signtool to path"
Copy-Item "$($package.InstallLocation)\SDK\signtool.exe" "$([Environment]::SystemDirectory)\signtool.exe"

Write-Output "Verifying required tools are accesible"
Invoke-Expression "MsixPackagingTool.exe --version"
Invoke-Expression "signtool.exe sign /?"
