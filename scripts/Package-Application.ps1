param(
    # Path of the applications installation file
    [Parameter(Mandatory=$true)]
    [String]
    $InstallationFilePath,

    # Path of the application's XML template
    [Parameter(Mandatory=$true)]
    [String]
    $ApplicationTemplateFilePath,

    # Path to where the outputed MSIX package should be put
    [Parameter(Mandatory=$true)]
    [String]
    $MSIXOutputFilePath
)

Write-Output "Updating XML file..."
$templateFile = [xml](Get-Content -Path $ApplicationTemplateFilePath)
$templateFile.MsixPackagingToolTemplate.Installer.Path = $InstallationFilePath
$templateFile.MsixPackagingToolTemplate.SaveLocation.PackagePath = $MSIXOutputFilePath
$templateFile.MsixPackagingToolTemplate.SaveLocation.TemplatePath = $ApplicationTemplateFilePath
$templateFile.Save($ApplicationTemplateFilePath)
Write-Output "XML file updated."

$createPackageCmd = "MsixPackagingTool.exe create-package --template $ApplicationTemplateFilePath -v"
Write-Output "Executing $createPackageCmd"
Invoke-Command $createPackageCmd
