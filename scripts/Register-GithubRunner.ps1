param(
    # The url of the runner package
    [Parameter(Mandatory=$true)]
    [String]
    $RunnerPackageUrl,

    # The SHA256 hash of the runner package
    [Parameter(Mandatory=$true)]
    [String]
    $RunnerPackageHash,

    # The token required to register the token
    [Parameter(Mandatory=$true)]
    [String]
    $Token
)

mkdir "C:\actions-runner"
Set-Location "C:\actions-runner"

Invoke-WebRequest -Uri $RunnerPackageUrl -OutFile actions-runner-win-x64.zip
if((Get-FileHash -Path actions-runner-win-x64.zip -Algorithm SHA256).Hash.ToUpper() -ne $RunnerPackageHash.ToUpper()){ throw 'Computed checksum did not match' }

Add-Type -AssemblyName System.IO.Compression.FileSystem ; [System.IO.Compression.ZipFile]::ExtractToDirectory("$PWD/actions-runner-win-x64.zip", "$PWD")

./config.cmd --url https://github.com/sindkor/msix-packaging --token $Token --ephemeral
./run.cmd
