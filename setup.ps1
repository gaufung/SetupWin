Write-Information "Installing oh-my-posh"
winget install JanDeDobbeleer.OhMyPosh

Write-Information "Downloading CascadiaCode font family"
$uri = "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/CascadiaCode.zip"
Invoke-RestMethod -Uri $uri -OutFile "$($env:TEMP)/cascadiacode.zip"
Expand-Archive -Path "$($env:TEMP)/cascadiacode.zip" -DestinationPath "C:\Windows\Fonts\" -Force
Write-Information "Installing PSReadLine module"
Install-Module PSReadLine -RequiredVersion 2.2.0-beta1 -AllowPrerelease -Force

Write-Information "Downloading omp json file"



