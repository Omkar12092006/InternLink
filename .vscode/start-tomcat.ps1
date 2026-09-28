$ErrorActionPreference = "Stop"

$existingServer = Get-NetTCPConnection -LocalPort 8081 -State Listen -ErrorAction SilentlyContinue
if ($existingServer) {
    Write-Output "Server startup in existing Tomcat process on port 8081."
    exit 0
}

$javaHome = Get-ChildItem "C:\Program Files\Java\jdk-*" -Directory |
    Sort-Object Name |
    Select-Object -Last 1

if (-not $javaHome) {
    throw "Install a JDK to start InternLink."
}

$env:JAVA_HOME = $javaHome.FullName
$tomcatRoot = Join-Path $PSScriptRoot "..\target\tomcat"
$catalina = Join-Path $tomcatRoot "bin\catalina.bat"

if (-not (Test-Path $catalina)) {
    Write-Output "Preparing Tomcat before startup."
    & (Join-Path $PSScriptRoot "setup-tomcat.ps1")
    if ($LASTEXITCODE -ne 0 -or -not (Test-Path $catalina)) {
        throw "Tomcat preparation failed."
    }
}

$env:CATALINA_HOME = (Resolve-Path $tomcatRoot).Path
& $catalina run
