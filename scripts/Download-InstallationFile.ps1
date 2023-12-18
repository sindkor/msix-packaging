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
    $DownloadFileName,

    # Path to temp directory (will be created), defaults to $env:TEMP\MSIXInstallationFiles
    [Parameter(Mandatory=$false)]
    [String]
    $TempDirectoryPath = "$env:TEMP\MSIXInstallationFiles"
)

Write-Output "Downloading installation files"
Invoke-WebRequest $InstallationFileUrl -OutFile "$TempDirectoryPath\$DownloadFileName"

if ($InstallationFileChecksum -eq (Get-FileHash "$TempDirectoryPath\$DownloadFileName" -Algorithm SHA256).Hash) {
    Write-Output "File checksum match"
} else {
    throw "Bad installation file checksum"
}

if ([IO.Path]::GetExtension("$TempDirectoryPath\$DownloadFileName") -eq ".zip") {
    Write-Output "Downloaded file is a zip-file. Extracting contents to $TempDirectoryPath."
    Expand-Archive -LiteralPath "$TempDirectoryPath\$DownloadFileName" -DestinationPath $TempDirectoryPath
}
