$ErrorActionPreference = "Stop"

$tomcatVersion = "10.1.43"
$tomcatRoot = Join-Path $PSScriptRoot "..\target\tomcat"
$tomcatZip = Join-Path $PSScriptRoot "..\target\apache-tomcat-$tomcatVersion.zip"
$downloadUrl = "https://archive.apache.org/dist/tomcat/tomcat-10/v$tomcatVersion/bin/apache-tomcat-$tomcatVersion.zip"
$warPath = Join-Path $PSScriptRoot "..\target\InternLink-1.0-SNAPSHOT.war"

& "C:\Program Files\Apache\apache-maven-3.9.16\bin\mvn.cmd" package -DskipTests
if ($LASTEXITCODE -ne 0) {
    throw "Maven failed to build the InternLink WAR."
}

if (-not (Test-Path $tomcatRoot)) {
    if ((Test-Path $tomcatZip) -and ((Get-Item $tomcatZip).Length -eq 0)) {
        Remove-Item $tomcatZip -Force
    }
    if (-not (Test-Path $tomcatZip)) {
        Invoke-WebRequest -Uri $downloadUrl -OutFile $tomcatZip
    }

    $extractRoot = Join-Path $PSScriptRoot "..\target\tomcat-extract"
    if (Test-Path $extractRoot) {
        Remove-Item $extractRoot -Recurse -Force
    }
    Expand-Archive -Path $tomcatZip -DestinationPath $extractRoot
    Move-Item (Join-Path $extractRoot "apache-tomcat-$tomcatVersion") $tomcatRoot
    Remove-Item $extractRoot -Recurse -Force
}

$webappsPath = Join-Path $tomcatRoot "webapps"
New-Item -ItemType Directory -Path $webappsPath -Force | Out-Null
Copy-Item $warPath (Join-Path $webappsPath "InternLink.war") -Force

$serverXml = Join-Path $tomcatRoot "conf\server.xml"
$serverConfig = Get-Content $serverXml -Raw
$serverConfig = $serverConfig -replace 'port="8080"', 'port="8081"'
$serverConfig = $serverConfig -replace 'port="8005"', 'port="8006"'
Set-Content -Path $serverXml -Value $serverConfig -Encoding UTF8
