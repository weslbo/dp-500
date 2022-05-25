# Install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Install Software
choco install visualstudiocode -y
choco install git -y 
choco install nodejs-lts -y
choco install notepadplusplus -y
choco install azure-cli -y
choco install azurepowershell -y
choco install azcopy -y
choco install microsoft-windows-terminal --pre -y
choco install powerbi -y
choco install daxstudio -y
choco install azure-data-studio -y
