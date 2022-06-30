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
choco install powerbi -y --ignore-checksums
choco install daxstudio -y
choco install azure-data-studio -y
choco install powerbi-reportbuilder -y
choco install pwsh -y
choco install tabular-editor -y

# Clone dp-500 repositories
mdkir C:\DP-500
git clone --depth 1 https://github.com/weslbo/dp-500 C:\DP-500-DEMO
git clone --depth 1 https://github.com/MicrosoftLearning/DP-500-Azure-Data-Analyst C:\DP-500

& 'C:\Program Files\PowerShell\7\pwsh.exe'

# Install Data Gateway
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Install-Module -Name DataGateway -Force

# Import-Module -Name DataGateway
# Install-DataGateway (Login first with Login-DataGatewayServiceAccount)