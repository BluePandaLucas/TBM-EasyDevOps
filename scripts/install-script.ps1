# Script door mij (chatgpt)

# Zorg dat het script wordt uitgevoerd met Administrator rechten
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Dit script moet als administrator worden uitgevoerd." -ForegroundColor Red
    exit 1
}

# Functie om een bestand te downloaden
function Invoke-Download-File {
    param (
        [string]$Url,
        [string]$Destination
    )
    Write-Host "Downloading: $Url" -ForegroundColor Green
    Invoke-WebRequest -Uri $Url -OutFile $Destination -UseBasicParsing
}

# Installatie van .NET SDK 8
function Install-DotNetSDK {
    Write-Host "Bezig met installeren van .NET SDK 8..." -ForegroundColor Cyan
    $dotnetDownloadUrl = "https://download.visualstudio.microsoft.com/download/pr/702bd4cb-b8dd-4a9e-a6b5-3bcb9eaa2425/2ddc939ca206f3b95f10ee2865c6d1dd/dotnet-sdk-8.0.100-win-x64.exe"
    $dotnetInstaller = "$env:TEMP\dotnet-sdk-8.0.100-win-x64.exe"

    Invoke-Download-File -Url $dotnetDownloadUrl -Destination $dotnetInstaller
    Start-Process -FilePath $dotnetInstaller -ArgumentList "/quiet" -Wait
    Remove-Item -Path $dotnetInstaller -Force

    Write-Host ".NET SDK 8 installatie voltooid!" -ForegroundColor Green
}

# Installatie van Git
function Install-Git {
    Write-Host "Bezig met installeren van Git..." -ForegroundColor Cyan
    $gitDownloadUrl = "https://github.com/git-for-windows/git/releases/latest/download/Git-2.42.0-64-bit.exe"
    $gitInstaller = "$env:TEMP\Git-2.42.0-64-bit.exe"

    Invoke-Download-File -Url $gitDownloadUrl -Destination $gitInstaller
    Start-Process -FilePath $gitInstaller -ArgumentList "/silent" -Wait
    Remove-Item -Path $gitInstaller -Force

    Write-Host "Git installatie voltooid!" -ForegroundColor Green
}

# Clone een Git-repository
function Clone-GitRepo {
    param (
        [string]$RepositoryUrl,
        [string]$DestinationPath
    )
    Write-Host "Cloning repository: $RepositoryUrl" -ForegroundColor Cyan

    # Zorg ervoor dat Git is toegevoegd aan PATH
    $env:Path += ";C:\Program Files\Git\cmd"

    # Voer het clone-commando uit
    git clone $RepositoryUrl $DestinationPath
    Write-Host "Repository gekloond naar: $DestinationPath" -ForegroundColor Green
}

# Voer dotnet run uit in de geclonede repository
function Run-DotNetProject {
    param (
        [string]$ProjectPath
    )
    Write-Host "Bezig met uitvoeren van dotnet run in: $ProjectPath" -ForegroundColor Cyan

    # Normaliseer het pad naar een absoluut pad
    $absolutePath = Resolve-Path -Path $ProjectPath | Select-Object -ExpandProperty Path

    # Voer dotnet run uit
    Push-Location -Path $absolutePath
    try {
        dotnet run
    } catch {
        Write-Host "Fout bij het uitvoeren van dotnet run: $_" -ForegroundColor Red
    } finally {
        Pop-Location
    }
}

$repositoryUrl = "https://github.com/BluePandaLucas/TBM-EasyDevOps.git"
$destinationPath = ".\TBM-EasyDevOps"
$frontendPath = ".\TBM-EasyDevOps\frontend"

# Controleer of het script als administrator draait en installeer de tools
try {
    Install-DotNetSDK
    Install-Git
    Clone-GitRepo -RepositoryUrl $repositoryUrl -DestinationPath $destinationPath
    Run-DotNetProject -ProjectPath $frontendPath
} catch {
    Write-Host "Er is een fout opgetreden tijdens de installatie: $_" -ForegroundColor Red
}
