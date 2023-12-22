param(
    # URL to the installation file that is to be downloaded. Will be unpacked if it's a zip file.
    [Parameter(Mandatory=$true)]
    [String]
    $InstallationFileUrl,

    # The SHA256 checksum of the installation file
    [Parameter(Mandatory=$true)]
    [String]
    $InstallationFileChecksum,

    # The file name to save the downloaded file as, e.g. InstallationFile.msi or InstallationPackage.zip
    [Parameter(Mandatory=$true)]
    [String]
    $InstallationFileName,

    # Path to temp directory (will be created), defaults to $env:TEMP\MSIXInstallationFiles
    [Parameter(Mandatory=$false)]
    [String]
    $TempDirectoryPath = "$env:TEMP\MSIXInstallationFiles"
)

if (Test-Path $TempDirectoryPath) {
    Write-Output "Temp directory already exists"
} else {
    Write-Output "Creating temp directory"
    New-Item -ItemType Directory $TempDirectoryPath
}

Write-Output "Downloading installation files"
Invoke-WebRequest $InstallationFileUrl -OutFile "$TempDirectoryPath\$InstallationFileName"

if ($InstallationFileChecksum -eq (Get-FileHash "$TempDirectoryPath\$InstallationFileName" -Algorithm SHA256).Hash) {
    Write-Output "File checksum match"
} else {
    Remove-Item "$TempDirectoryPath\$InstallationFileName"
    throw "Bad installation file checksum"
}

if ([IO.Path]::GetExtension("$TempDirectoryPath\$InstallationFileName") -eq ".zip") {
    Write-Output "Downloaded file is a zip-file. Extracting contents to $TempDirectoryPath."
    Expand-Archive -LiteralPath "$TempDirectoryPath\$InstallationFileName" -DestinationPath $TempDirectoryPath
}
