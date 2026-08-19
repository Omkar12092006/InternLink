# Kill any existing Java processes
Get-Process java -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep -Seconds 3

# Set environment variables
$env:JAVA_HOME = "C:\Program Files\Java\jdk-25.0.2"
$env:CATALINA_HOME = "C:\JAVA\apache-tomcat-11.0.23"

# Start Tomcat
Write-Host "Starting Tomcat..."
& "C:\JAVA\apache-tomcat-11.0.23\bin\startup.bat"
Start-Sleep -Seconds 5
Write-Host "Tomcat started. Application should be available at http://localhost:8080/InternLink-1.0-SNAPSHOT/"
