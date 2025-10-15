# --- SCRIPT START ------------------------------------------------------------
# Ensure script is running as Administrator
If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
  Write-Host "Please rerun with elevated privileges."
  Exit
}

# --- BLOATWARE REMOVAL -------------------------------------------------------
Write-Host "Removing Pre-installed Apps and Features. Please wait . . ." -ForegroundColor Yellow

# List of bloatware to remove (Modern Apps)
$bloatwareApps = @(
  'Microsoft.Microsoft3DViewer', 'Microsoft.BingSearch', 'Microsoft.WindowsCamera', 'Clipchamp.Clipchamp',
  'Microsoft.WindowsAlarms', 'Microsoft.549981C3F5F10', 'Microsoft.Windows.DevHome',
  'MicrosoftCorporationII.MicrosoftFamily', 'Microsoft.WindowsFeedbackHub', 'Microsoft.GetHelp',
  'microsoft.windowscommunicationsapps', 'Microsoft.WindowsMaps', 'Microsoft.ZuneVideo',
  'Microsoft.BingNews', 'Microsoft.MicrosoftOfficeHub', 'Microsoft.Office.OneNote',
  'Microsoft.OutlookForWindows', 'Microsoft.People', 'Microsoft.PowerAutomateDesktop',
  'MicrosoftCorporationII.QuickAssist', 'Microsoft.SkypeApp', 'Microsoft.MicrosoftSolitaireCollection',
  'Microsoft.MicrosoftStickyNotes', 'MSTeams', 'Microsoft.Getstarted', 'Microsoft.Todos',
  'Microsoft.WindowsSoundRecorder', 'Microsoft.BingWeather', 'Microsoft.ZuneMusic', 'Microsoft.MSPaint',
  'Microsoft.Xbox.TCUI', 'Microsoft.XboxApp', 'Microsoft.XboxGameOverlay', 'Microsoft.XboxGamingOverlay',
  'Microsoft.XboxIdentityProvider', 'Microsoft.XboxSpeechToTextOverlay', 'Microsoft.GamingApp',
  'Microsoft.YourPhone', 'Microsoft.OneDrive', 'Microsoft.549981C3F5F10', 'Microsoft.MixedReality.Portal',
  'Microsoft.Windows.Ai.Copilot.Provider', 'Microsoft.Copilot', 'Microsoft.Copilot_8wekyb3d8bbwe',
	'Microsoft.WindowsMeetNow', 'Microsoft.WindowsStore', 'Microsoft.Paint'
)

# Define Legacy Windows Features & Apps to Remove
$legacyWindowsFeatures = @(
  'Browser.InternetExplorer', 'MathRecognizer', 'OpenSSH.Client',
  'Microsoft.Windows.PowerShell.ISE', 'App.Support.QuickAssist', 'App.StepsRecorder',
  'Media.WindowsMediaPlayer', 'Microsoft.Windows.WordPad', 'Microsoft.Windows.MSPaint'
)

# Remove Bloatware Apps
Get-AppxPackage -AllUsers |
Where-Object { $bloatwareApps -contains $_.Name } |
Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue | Out-Null

# Remove Legacy Windows Features & Apps
Get-WindowsCapability -Online |
Where-Object { $legacyWindowsFeatures -contains ($_.Name -split '~')[0] } |
Remove-WindowsCapability -Online -ErrorAction SilentlyContinue | Out-Null

# --- REGISTRY MODIFICATIONS --------------------------------------------------
Write-Host "Applying registry modifications to prevent feature reinstallation and disable unwanted features." -ForegroundColor Yellow

$regFileContent = @"
Windows Registry Editor Version 5.00

; -- Application and Feature Restrictions --

; Disable Windows Copilot system-wide
[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot]
"TurnOffWindowsCopilot"=dword:00000001

; Prevents Dev Home Installation
[-HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsUpdate\Orchestrator\UScheduler_Oobe\DevHomeUpdate]

; Prevents New Outlook for Windows Installation
[-HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsUpdate\Orchestrator\UScheduler_Oobe\OutlookUpdate]

; Prevents Chat Auto Installation
[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Communications]
"ConfigureChatAutoInstall"=dword:00000000

[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Chat]
"ChatIcon"=dword:00000003

; Disables Cortana
[HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\Windows Search]
"AllowCortana"=dword:00000000

; Disables OneDrive Automatic Backups of Important Folders (Documents, Pictures etc.)
[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\OneDrive]
"KFMBlockOptIn"=dword:00000001

; -- Privacy and Security Settings --

; Disables Activity History
[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\System]
"EnableActivityFeed"=dword:00000000
"PublishUserActivities"=dword:00000000
"UploadUserActivities"=dword:00000000

; Disables Location Tracking
[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location]
"Value"="Deny"

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}]
"SensorPermissionState"=dword:00000000

[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration]
"Status"=dword:00000000

[HKEY_LOCAL_MACHINE\SYSTEM\Maps]
"AutoUpdateEnabled"=dword:00000000

; Disables Telemetry
[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection]
"AllowTelemetry"=dword:00000000

; Disables Telemetry and Feedback Notifications
[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\DataCollection]
"AllowTelemetry"=dword:00000000
"DoNotShowFeedbackNotifications"=dword:00000001

; Disables Windows Ink Workspace
[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsInkWorkspace]
"AllowWindowsInkWorkspace"=dword:00000000

; Disables the Advertising ID for All Users
[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo]
"DisabledByGroupPolicy"=dword:00000001

; Disable Account Info
[HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation]
"Value"="Deny"
"@

# Write registry content to a file and apply
$regFilePath = "$env:TEMP\Recommended_Privacy_Settings.reg"
Set-Content -Path $regFilePath -Value $regFileContent -Force
Start-Process -FilePath "regedit.exe" -ArgumentList "/S `"$regFilePath`"" -NoNewWindow -Wait

# Uninstall and Clean OneDrive
Write-Host "Uninstalling OneDrive..." -ForegroundColor Yellow

Stop-Process -Force -Name OneDrive -ErrorAction SilentlyContinue | Out-Null
cmd /c "C:\Windows\SysWOW64\OneDriveSetup.exe -uninstall >nul 2>&1"
Get-ScheduledTask | Where-Object { $_.Taskname -match 'OneDrive' } | Unregister-ScheduledTask -Confirm:$false
cmd /c "C:\Windows\System32\OneDriveSetup.exe -uninstall >nul 2>&1"

# Disable Recall feature
Write-Host "Disabling Recall feature..." -ForegroundColor Yellow
Dism /Online /Disable-Feature /Featurename:Recall /NoRestart | Out-Null
