$ErrorActionPreference = "Stop"

$tomcatVersion = "10.1.43"
$tomcatRoot = Join-Path $PSScriptRoot "..\target\tomcat"
$tomcatZip = Join-Path $PSScriptRoot "..\target\apache-tomcat-$tomcatVersion.zip"
$downloadUrl = "https://archive.apache.org/dist/tomcat/tomcat-10/v$tomcatVersion/bin/apache-tomcat-$tomcatVersion.zip"
$warPath = Join-Path $PSScriptRoot "..\target\InternLink-1.0-SNAPSHOT.war"

$mavenCandidates = @()
$mavenOnPath = Get-Command mvn.cmd, mvn -ErrorAction SilentlyContinue |
    Where-Object { $_.CommandType -eq "Application" } |
    Select-Object -First 1
if ($mavenOnPath) {
    $mavenCandidates += $mavenOnPath.Source
}

$mavenHomes = @($env:MAVEN_HOME, $env:M2_HOME) | Where-Object { $_ } | Select-Object -Unique
foreach ($mavenHome in $mavenHomes) {
    $mavenCandidates += (Join-Path $mavenHome "mvn.cmd")
    $mavenCandidates += (Join-Path $mavenHome "bin\mvn.cmd")
}

foreach ($programFiles in @($env:ProgramFiles, ${env:ProgramFiles(x86)}) | Where-Object { $_ }) {
    $apacheDirectory = Join-Path $programFiles "Apache"
    if (Test-Path $apacheDirectory) {
        $mavenCandidates += Get-ChildItem $apacheDirectory -Directory -Filter "apache-maven-*" -ErrorAction SilentlyContinue |
            ForEach-Object { Join-Path $_.FullName "bin\mvn.cmd" }
    }
}

$mvnPath = $mavenCandidates |
    Where-Object { $_ -and (Test-Path $_ -PathType Leaf) } |
    Select-Object -First 1
if (-not $mvnPath) {
    throw "Maven was not found. Add Maven's bin folder to PATH or set MAVEN_HOME to its installation or bin folder."
}

$mavenBin = Split-Path $mvnPath -Parent
$env:PATH = "$mavenBin;$env:PATH"
Write-Output "Building InternLink with Maven at $mvnPath"

& $mvnPath package -DskipTests
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
