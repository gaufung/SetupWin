#Requires -RunAsAdministrator

[CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
param ()

if ($PSVersionTable.PSVersion.Major -ne 7) {
    if ($PSCmdlet.ShouldProcess(
        'Warning: You are not executing with PowerShell Core 7',
        'Question: Are you want to install PowerShell Core 7')) {
            Invoke-Expression "& { $(Invoke-RestMethod https://aka.ms/install-powershell.ps1) } -UseMSI"
    }
    return
}

if (Test-Path "$($env:ProgramData)\chocolatey") {
    if (($env:Path -split ";") -ne "$($env:ProgramData)\chocolatey\bin") {
        Write-Verbose "chocolatey is not in the PATH" 
        $env:Path += ";$($env:ProgramData)\chocolatey\bin"
    } else {
        Write-Verbose "chocolatey has already installed"
    }
}
else {
    Write-Host "Installing chocolatey" -ForegroundColor Cyan
    Set-ExecutionPolicy Bypass -Scope Process -Force; 
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; 
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}


Write-Host "Installing dotnet" -ForegroundColor Cyan 
choco install dotnet-sdk
choco install dotnet-sdk --version=5.0.403

Write-Host "Installing Visual Studio Code" -ForegroundColor Cyan
choco install vscode

Write-Host "Installing Microsoft Edge Browser" -ForegroundColor Cyan
choco install microsoft-edge

Write-Host "Installing Git" -ForegroundColor Cyan 
choco install git
[System.Environment]::SetEnvironmentVariable(
    "Path",
    [System.Environment]::GetEnvironmentVariable("PATH", [System.Environment]::MachineName) + ";C:\Program Files\Git\bin",
    [System.EnvironmentVariableTarget]::MachineName
)

Write-Host "Installing Python 3.x" -ForegroundColor Cyan 
choco install python

Write-Host "Installing oh-my-posh" -ForegroundColor Cyan
choco install oh-my-posh

Write-Host "Installing Windows Terminal" -ForegroundColor Cyan 
choco install microsoft-windows-terminal

Write-Host "Installing CascadiaCode font family" -ForegroundColor Cyan
$uri = "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/CascadiaCode.zip"
Invoke-RestMethod -Uri $uri -OutFile "$($env:TEMP)/cascadiacode.zip"
Expand-Archive -Path "$($env:TEMP)/cascadiacode.zip" -DestinationPath "C:\Windows\Fonts\" -Force

Write-Host "Installing PSReadLine module" -ForegroundColor Cyan
Install-Module PSReadLine -RequiredVersion 2.2.0-beta1 -AllowPrerelease -Force

Write-Host "Installing Terminal-Icons module"
Install-Module Terminal-Icons

Write-Host "Downloading omp json file" -ForegroundColor Cyan
$omp = Invoke-RestMethod -Uri "https://raw.githubusercontent.com/gaufung/SetupWin/master/user.omp.json" -Method GET
$omp | ConvertTo-Json -Depth 99 | Out-File "$HOME\$env:UserName.omp.json" -Force

Write-Host "Installing profile.ps1"
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/gaufung/SetupWin/master/Profile_Core.ps1" -OutFile $PROFILE