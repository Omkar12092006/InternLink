$ErrorActionPreference = "Stop"

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
    throw "Tomcat is not prepared. Run the 'InternLink: prepare Tomcat' task first."
}

$env:CATALINA_HOME = (Resolve-Path $tomcatRoot).Path
& $catalina run
