# Ensure the script is running as Administrator
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "You must run this script as an Administrator."
    Pause
    Exit
}

Write-Host "Starting Windows 11 Debloat & AI Removal..." -ForegroundColor Cyan
Write-Host "----------------------------------------------" -ForegroundColor Cyan

# 0. Set System Execution Policy Permanently
Write-Host "Setting system Execution Policy to allow running local scripts..." -ForegroundColor Yellow
Set-ExecutionPolicy RemoteSigned -Scope LocalMachine -Force
Write-Host "[SUCCESS] System Execution Policy permanently set to RemoteSigned." -ForegroundColor Green
Write-Host "----------------------------------------------" -ForegroundColor Cyan

# 1. Disable Cortana and Bing Search
Write-Host "Disabling Cortana and Bing Search..." -ForegroundColor Yellow
$SearchKey = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search"
if (!(Test-Path $SearchKey)) { New-Item -Path $SearchKey -Force | Out-Null }
Set-ItemProperty -Path $SearchKey -Name "CortanaConsent" -Type DWord -Value 0 -ErrorAction SilentlyContinue
Set-ItemProperty -Path $SearchKey -Name "BingSearchEnabled" -Type DWord -Value 0 -ErrorAction SilentlyContinue
Write-Host "[SUCCESS] Cortana and Bing Search disabled." -ForegroundColor Green
Write-Host "----------------------------------------------" -ForegroundColor Cyan

# 2. Disable Windows Telemetry & Data Collection
Write-Host "Disabling Telemetry and Data Collection..." -ForegroundColor Yellow
$TelemetryKey1 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
$TelemetryKey2 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
if (!(Test-Path $TelemetryKey1)) { New-Item -Path $TelemetryKey1 -Force | Out-Null }
if (!(Test-Path $TelemetryKey2)) { New-Item -Path $TelemetryKey2 -Force | Out-Null }
Set-ItemProperty -Path $TelemetryKey1 -Name "AllowTelemetry" -Type DWord -Value 0 -ErrorAction SilentlyContinue
Set-ItemProperty -Path $TelemetryKey2 -Name "AllowTelemetry" -Type DWord -Value 0 -ErrorAction SilentlyContinue

Stop-Service -Name "DiagTrack" -WarningAction SilentlyContinue
Set-Service -Name "DiagTrack" -StartupType Disabled -WarningAction SilentlyContinue
Stop-Service -Name "dmwappushservice" -WarningAction SilentlyContinue
Set-Service -Name "dmwappushservice" -StartupType Disabled -WarningAction SilentlyContinue
Write-Host "[SUCCESS] Telemetry and Data Collection disabled." -ForegroundColor Green
Write-Host "----------------------------------------------" -ForegroundColor Cyan

# 3. Disable Windows Copilot
Write-Host "Disabling Windows Copilot..." -ForegroundColor Yellow
$CopilotKey = "HKCU:\Software\Policies\Microsoft\Windows\WindowsCopilot"
if (!(Test-Path $CopilotKey)) { New-Item -Path $CopilotKey -Force | Out-Null }
Set-ItemProperty -Path $CopilotKey -Name "TurnOffWindowsCopilot" -Type DWord -Value 1 -ErrorAction SilentlyContinue
Write-Host "[SUCCESS] Windows Copilot disabled." -ForegroundColor Green
Write-Host "----------------------------------------------" -ForegroundColor Cyan
Pause

# 4. Run Zoicware RemoveWindowsAI Script
Write-Host "Running Zoicware RemoveWindowsAI Script..." -ForegroundColor Yellow
Invoke-Expression "& { $(Invoke-RestMethod 'https://raw.githubusercontent.com/zoicware/RemoveWindowsAI/main/RemoveWindowsAi.ps1') } -nonInteractive -backupMode -AllOptions"
Write-Host "[SUCCESS] Zoicware AI Removal process finished." -ForegroundColor Green
Write-Host "----------------------------------------------" -ForegroundColor Cyan
Pause

# 5. Run Raphi Debloat Script
Write-Host "Running Raphi Debloat Script..." -ForegroundColor Yellow
Invoke-Expression "& { $(Invoke-RestMethod 'https://debloat.raphi.re/') }"
Write-Host "[SUCCESS] Raphi Debloat process finished." -ForegroundColor Green
Write-Host "----------------------------------------------" -ForegroundColor Cyan
Pause

Write-Host "All tasks completed successfully! Please restart your computer to apply all changes." -ForegroundColor Black -BackgroundColor Green
Pause
