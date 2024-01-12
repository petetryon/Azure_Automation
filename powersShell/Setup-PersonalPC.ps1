# Choco wrapper
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force
function Install-ChocoPackage($packageName) {
    $sw = Measure-Command {
        Write-Host "Installing/upgrading" $packageName "from Chocolatey" -ForegroundColor DarkGreen -NoNewline
        choco upgrade $packageName -y -source https://chocolatey.org/api/v2/
    }

    Write-Host " -" $sw.TotalSeconds "seconds" -ForegroundColor DarkGray
}

Write-Host "Installing Chocolatey" -foregroundcolor DarkGreen
Invoke-Expression ((New-Object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))

Install-ChocoPackage "GoogleChrome"
Install-ChocoPackage "notepadplusplus"
Install-ChocoPackage "7zip.install"
Install-ChocoPackage "Steam"
Install-ChocoPackage "windirstat"
