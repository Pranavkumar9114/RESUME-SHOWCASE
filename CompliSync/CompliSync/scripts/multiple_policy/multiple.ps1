$roamingAppData = [System.Environment]::GetFolderPath('ApplicationData')

$appFolder = Join-Path $roamingAppData "CompliSync"

$tempFolder = Join-Path $appFolder "Temp"

$logFilePath = Join-Path $tempFolder "multiple_policy_update_log.txt"

function Log-Message {
    param (
        [string]$message
    )
    Add-Content -Path $logFilePath -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - $message"
}

if (-Not (Test-Path $logFilePath)) {
    New-Item -Path $logFilePath -ItemType File -Force
} else {
    Clear-Content -Path $logFilePath -Force
}

try {
    Log-Message "=================================================="
    Log-Message "        Policy Update Log - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    Log-Message "=================================================="
    Log-Message ""

    Log-Message "--------------------------------------------------"
    Log-Message "          Default Policies Values"
    Log-Message "--------------------------------------------------"

    $currentPolicies = net accounts
    $currentPolicies | ForEach-Object { 
        if ($_ -notmatch 'Lockout threshold|Lockout observation window') {
            Log-Message $_
        }
    }

    secedit /export /cfg C:\secpol.cfg
    $complexityStatus = Select-String -Path C:\secpol.cfg -Pattern "PasswordComplexity = (\d)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ($complexityStatus -eq "1") {
        Log-Message "Password Complexity:                                  Enabled"
    } else {
        Log-Message "Password Complexity:                                  Disabled"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $updatedLockoutThreshold = Select-String -Path C:\secpol.cfg -Pattern "LockoutBadCount = (\d+)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ($updatedLockoutThreshold -gt 0 -and $updatedLockoutThreshold -le 5) {
        Log-Message "Account Lockout Threshold:                            Enabled ($updatedLockoutThreshold)"
    } else {
        Log-Message "Account Lockout Threshold:                            Disabled or Not Set"
    }
    Remove-Item -Path C:\secpol.cfg -Force   


    secedit /export /cfg C:\secpol.cfg
    $updatedEncryptionStatus = Select-String -Path C:\secpol.cfg -Pattern "ClearTextPassword = (\d)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ($updatedEncryptionStatus -eq "0") {
        Log-Message "Store passwords using reversible encryption:          Disabled"
    } else {
        Log-Message "Store passwords using reversible encryption:          Enabled"
    }
    Remove-Item -Path C:\secpol.cfg -Force    


    secedit /export /cfg C:\secpol.cfg
    $updatedAdminLockoutStatus = Select-String -Path C:\secpol.cfg -Pattern "AllowAdministratorLockout = (\d)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ($updatedAdminLockoutStatus -eq "1") {
        Log-Message "Allow Administrator account lockout:                  Enabled"
    } else {
        Log-Message "Allow Administrator account lockout:                  Disabled"
    }
    Remove-Item -Path C:\secpol.cfg -Force 


    secedit /export /cfg C:\secpol.cfg
    $updatedLockoutCounter = Select-String -Path C:\secpol.cfg -Pattern "ResetLockoutCount = (\d+)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ($updatedLockoutCounter -ge 15) {
        Log-Message "Reset account lockout counter after:                  $updatedLockoutCounter minutes"
    } else {
        Log-Message "Reset account lockout counter after:                  Not Configured or Less than 15 minutes"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $updatedCredentialManager = Select-String -Path C:\secpol.cfg -Pattern "SeTrustedCredManAccessPrivilege = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ([string]::IsNullOrWhiteSpace($updatedCredentialManager)) {
        Log-Message "Access Credential Manager as a trusted caller:        No One"
    } else {
        Log-Message "Access Credential Manager as a trusted caller:        $updatedCredentialManager"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $updatedNetworkAccess = Select-String -Path C:\secpol.cfg -Pattern "SeNetworkLogonRight = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ($updatedNetworkAccess -match "Administrators,Remote Desktop Users") {
        Log-Message "Access this computer from the network:               Administrators, Remote Desktop Users"
    } else {
        Log-Message "Access this computer from the network:               $updatedNetworkAccess"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $updatedActAsSystem = Select-String -Path C:\secpol.cfg -Pattern "SeTcbPrivilege = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if (-not $updatedActAsSystem) {
        Log-Message "Act as part of the operating system:                   No One"
    } else {
        Log-Message "Act as part of the operating system:                   $updatedActAsSystem"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $updatedMemoryQuotas = Select-String -Path C:\secpol.cfg -Pattern "SeIncreaseQuotaPrivilege = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    Log-Message "Adjust memory quotas for a process:                  $updatedMemoryQuotas"
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $updatedLocalLogon = Select-String -Path C:\secpol.cfg -Pattern "SeInteractiveLogonRight = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ($updatedLocalLogon -match "Administrators,Users") {
        Log-Message "Allow log on locally:                                Administrators, Users"
    } else {
        Log-Message "Allow log on locally:                                $updatedLocalLogon"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $updatedRdpLogon = Select-String -Path C:\secpol.cfg -Pattern "SeRemoteInteractiveLogonRight = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ($updatedRdpLogon -match "Administrators,Remote Desktop Users") {
        Log-Message "Allow log on through Remote Desktop Services:        Administrators, Remote Desktop Users"
    } else {
        Log-Message "Allow log on through Remote Desktop Services:        $updatedRdpLogon"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $updatedBackupPrivilege = Select-String -Path C:\secpol.cfg -Pattern "SeBackupPrivilege = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ($updatedBackupPrivilege -match "Administrators") {
        Log-Message "Back up files and directories:                       Administrators"
    } else {
        Log-Message "Back up files and directories:                       $updatedBackupPrivilege"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $updatedTimePrivilege = Select-String -Path C:\secpol.cfg -Pattern "SeTimeZonePrivilege = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ($updatedTimePrivilege -match "Administrators, LOCAL SERVICE") {
        Log-Message "Change the system time:                              Administrators, LOCAL SERVICE"
    } else {
        Log-Message "Change the system time:                              $updatedTimePrivilege"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $updatedPagefilePrivilege = Select-String -Path C:\secpol.cfg -Pattern "SeCreatePagefilePrivilege = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ($updatedPagefilePrivilege -match "Administrators") {
        Log-Message "Create a pagefile:                                   Administrators"
    } else {
        Log-Message "Create a pagefile:                                   $updatedPagefilePrivilege"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $updatedTokenPrivilege = Select-String -Path C:\secpol.cfg -Pattern "SeCreateTokenPrivilege = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ([string]::IsNullOrWhiteSpace($updatedTokenPrivilege)) {
        Log-Message "Create a token object:                               No One"
    } else {
        Log-Message "Create a token object:                               $updatedTokenPrivilege"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $updatedGlobalPrivilege = Select-String -Path C:\secpol.cfg -Pattern "SeCreateGlobalPrivilege = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ([string]::IsNullOrWhiteSpace($updatedGlobalPrivilege)) {
        Log-Message "Create global objects:                               No One"
    } else {
        Log-Message "Create global objects:                               $updatedGlobalPrivilege"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $updatedPermanentPrivilege = Select-String -Path C:\secpol.cfg -Pattern "SeCreatePermanentPrivilege = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ([string]::IsNullOrWhiteSpace($updatedPermanentPrivilege)) {
        Log-Message "Create permanent shared objects:                     No One"
    } else {
        Log-Message "Create permanent shared objects:                     $updatedPermanentPrivilege"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $updatedSymbolicLinkPrivilege = Select-String -Path C:\secpol.cfg -Pattern "SeCreateSymbolicLinkPrivilege = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ([string]::IsNullOrWhiteSpace($updatedSymbolicLinkPrivilege)) {
        Log-Message "Create symbolic links:                               No One"
    } else {
        Log-Message "Create symbolic links:                               $updatedSymbolicLinkPrivilege"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $updatedDebugPrivilege = Select-String -Path C:\secpol.cfg -Pattern "SeDebugPrivilege = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ([string]::IsNullOrWhiteSpace($updatedDebugPrivilege)) {
        Log-Message "Debug programs:                                      No One"
    } else {
        Log-Message "Debug programs:                                      $updatedDebugPrivilege"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $updatedDenyNetwork = Select-String -Path C:\secpol.cfg -Pattern "SeDenyNetworkLogonRight = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ([string]::IsNullOrWhiteSpace($updatedDenyNetwork)) {
        Log-Message "Deny access to this computer from the network:       No One"
    } else {
        Log-Message "Deny access to this computer from the network:       $updatedDenyNetwork"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $updatedDenyBatch = Select-String -Path C:\secpol.cfg -Pattern "SeDenyBatchLogonRight = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ([string]::IsNullOrWhiteSpace($updatedDenyBatch)) {
        Log-Message "Deny log on as a batch job:                          No One"
    } else {
        Log-Message "Deny log on as a batch job:                          $updatedDenyBatch"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $updatedDenyService = Select-String -Path C:\secpol.cfg -Pattern "SeDenyServiceLogonRight = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ([string]::IsNullOrWhiteSpace($updatedDenyService)) {
        Log-Message "Deny log on as a service:                            No One"
    } else {
        Log-Message "Deny log on as a service:                            $updatedDenyService"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $updatedDenyInteractive = Select-String -Path C:\secpol.cfg -Pattern "SeDenyInteractiveLogonRight = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ([string]::IsNullOrWhiteSpace($updatedDenyInteractive)) {
        Log-Message "Deny log on locally:                                 No One"
    } else {
        Log-Message "Deny log on locally:                                 $updatedDenyInteractive"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $updatedDenyRDP = Select-String -Path C:\secpol.cfg -Pattern "SeDenyRemoteInteractiveLogonRight = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ([string]::IsNullOrWhiteSpace($updatedDenyRDP)) {
        Log-Message "Deny log on through Remote Desktop Services:         No One"
    } else {
        Log-Message "Deny log on through Remote Desktop Services:         $updatedDenyRDP"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $updatedDelegation = Select-String -Path C:\secpol.cfg -Pattern "SeEnableDelegationPrivilege = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ([string]::IsNullOrWhiteSpace($updatedDelegation)) {
        Log-Message "Enable computer and user accounts to be trusted for delegation:   No One"
    } else {
        Log-Message "Enable computer and user accounts to be trusted for delegation:   $updatedDelegation"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $shutdownSetting = Select-String -Path C:\secpol.cfg -Pattern "SeRemoteShutdownPrivilege\s*=\s*(.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ($shutdownSetting -match "S-1-5-32-544") {
        Log-Message "Force shutdown from a remote system:                 Administrators"
    } else {
        Log-Message "Force shutdown from a remote system:                 $shutdownSetting"
        }
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $updatedAudit = Select-String -Path C:\secpol.cfg -Pattern "SeAuditPrivilege = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ($updatedAudit -match "S-1-5-19" -and $updatedAudit -match "S-1-5-20") {
        Log-Message "Generate security audits:                            LOCAL SERVICE, NETWORK SERVICE"
    } elseif (-not [string]::IsNullOrWhiteSpace($updatedAudit)) {
        Log-Message "Generate security audits:                            $updatedAudit"
    } else {
        Log-Message "Generate security audits:                            Not configured"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $updatedImpersonate = Select-String -Path C:\secpol.cfg -Pattern "SeImpersonatePrivilege = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ([string]::IsNullOrWhiteSpace($updatedImpersonate)) {
        Log-Message "Impersonate a client after authentication:           No One"
    } else {
        Log-Message "Impersonate a client after authentication:           $updatedImpersonate"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $updatedPriority = Select-String -Path C:\secpol.cfg -Pattern "SeIncreaseBasePriorityPrivilege = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ([string]::IsNullOrWhiteSpace($updatedPriority)) {
        Log-Message "Increase scheduling priority:                        No One"
    } else {
        Log-Message "Increase scheduling priority:                        $updatedPriority"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $updatedDriverLoad = Select-String -Path C:\secpol.cfg -Pattern "SeLoadDriverPrivilege = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ([string]::IsNullOrWhiteSpace($updatedDriverLoad)) {
        Log-Message "Load and unload device drivers:                      No One"
    } else {
        Log-Message "Load and unload device drivers:                      $updatedDriverLoad"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $updatedLockPages = Select-String -Path C:\secpol.cfg -Pattern "SeLockMemoryPrivilege = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ([string]::IsNullOrWhiteSpace($updatedLockPages)) {
        Log-Message "Lock pages in memory:                                No One"
    } else {
        Log-Message "Lock pages in memory:                                $updatedLockPages"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $updatedBatchJob = Select-String -Path C:\secpol.cfg -Pattern "SeBatchLogonRight = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ([string]::IsNullOrWhiteSpace($updatedBatchJob)) {
        Log-Message "Log on as a batch job:                               Administrators"
    } else {
        Log-Message "Log on as a batch job:                               $updatedBatchJob"
    }
    Remove-Item -Path C:\secpol.cfg -Force



    secedit /export /cfg C:\secpol.cfg
    $updatedServiceLogon = Select-String -Path C:\secpol.cfg -Pattern "SeServiceLogonRight = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ([string]::IsNullOrWhiteSpace($updatedServiceLogon)) {
        Log-Message "Log on as a service:                                 No One"
    } else {
        Log-Message "Log on as a service:                                 $updatedServiceLogon"
    }
    Remove-Item -Path C:\secpol.cfg -Force



    secedit /export /cfg C:\secpol.cfg
    $updatedSecurityLog = Select-String -Path C:\secpol.cfg -Pattern "SeSecurityPrivilege = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ([string]::IsNullOrWhiteSpace($updatedSecurityLog)) {
        Log-Message "Manage auditing and security log:                    Administrators"
    } else {
        Log-Message "Manage auditing and security log:                    $updatedSecurityLog"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    
    secedit /export /cfg C:\secpol.cfg
    $updatedRelabel = Select-String -Path C:\secpol.cfg -Pattern "SeRelabelPrivilege = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ([string]::IsNullOrWhiteSpace($updatedRelabel)) {
        Log-Message "Modify an object label:                              No One"
    } else {
        Log-Message "Modify an object label:                              $updatedRelabel"
    }
    Remove-Item -Path C:\secpol.cfg -Force



    secedit /export /cfg C:\secpol.cfg
    $updatedFirmwareEnv = Select-String -Path C:\secpol.cfg -Pattern "SeSystemEnvironmentPrivilege = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ([string]::IsNullOrWhiteSpace($updatedFirmwareEnv)) {
        Log-Message "Modify firmware environment values:                  Administrators"
    } else {
        Log-Message "Modify firmware environment values:                  $updatedFirmwareEnv"
    }
    Remove-Item -Path C:\secpol.cfg -Force



    secedit /export /cfg C:\secpol.cfg
    $updatedVolumeTask = Select-String -Path C:\secpol.cfg -Pattern "SeManageVolumePrivilege = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ([string]::IsNullOrWhiteSpace($updatedVolumeTask)) {
        Log-Message "Perform volume maintenance tasks:                    Administrators"
    } else {
        Log-Message "Perform volume maintenance tasks:                    $updatedVolumeTask"
    }
    Remove-Item -Path C:\secpol.cfg -Force



    secedit /export /cfg C:\secpol.cfg
    $updatedProfileProcess = Select-String -Path C:\secpol.cfg -Pattern "SeProfileSingleProcessPrivilege = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ([string]::IsNullOrWhiteSpace($updatedProfileProcess)) {
        Log-Message "Profile single process:                              Administrators"
    } else {
        Log-Message "Profile single process:                              $updatedProfileProcess"
    }
    Remove-Item -Path C:\secpol.cfg -Force



    secedit /export /cfg C:\secpol.cfg
    $updatedSysPerf = Select-String -Path C:\secpol.cfg -Pattern "SeSystemProfilePrivilege = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ([string]::IsNullOrWhiteSpace($updatedSysPerf)) {
        Log-Message "Profile system performance:                          Administrators, NT SERVICE\WdiServiceHost"
    } else {
        Log-Message "Profile system performance:                          $updatedSysPerf"
    }
    Remove-Item -Path C:\secpol.cfg -Force



    secedit /export /cfg C:\secpol.cfg
    $updatedReplaceProcessToken = Select-String -Path C:\secpol.cfg -Pattern "SeReplaceProcessLevelTokenPrivilege = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ([string]::IsNullOrWhiteSpace($updatedReplaceProcessToken)) {
        Log-Message "Replace a process level token:                       LOCAL SERVICE, NETWORK SERVICE"
    } else {
        Log-Message "Replace a process level token:                       $updatedReplaceProcessToken"
    }
    Remove-Item -Path C:\secpol.cfg -Force



    secedit /export /cfg C:\secpol.cfg
    $updatedRestoreFiles = Select-String -Path C:\secpol.cfg -Pattern "SeRestorePrivilege = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ([string]::IsNullOrWhiteSpace($updatedRestoreFiles)) {
        Log-Message "Restore files and directories:                       Administrators"
    } else {
        Log-Message "Restore files and directories:                       $updatedRestoreFiles"
    }
    Remove-Item -Path C:\secpol.cfg -Force



    secedit /export /cfg C:\secpol.cfg
    $updatedShutdownSystem = Select-String -Path C:\secpol.cfg -Pattern "SeShutdownPrivilege = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ([string]::IsNullOrWhiteSpace($updatedShutdownSystem)) {
        Log-Message "Shut down the system:                                Administrators, Users"
    } else {
        Log-Message "Shut down the system:                                $updatedShutdownSystem"
    }
    Remove-Item -Path C:\secpol.cfg -Force



    secedit /export /cfg C:\secpol.cfg
    $updatedTakeOwnership = Select-String -Path C:\secpol.cfg -Pattern "SeTakeOwnershipPrivilege = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ([string]::IsNullOrWhiteSpace($updatedTakeOwnership)) {
        Log-Message "Take ownership of files or other objects:            Administrators"
    } else {
        Log-Message "Take ownership of files or other objects:            $updatedTakeOwnership"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    
    $registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
    $registryName = "NoConnectedUser"
    try {
        if (Test-Path $registryPath) {
            $currentValue = Get-ItemProperty -Path $registryPath -Name $registryName -ErrorAction SilentlyContinue
            if ($currentValue) {
                switch ($currentValue.$registryName) {
                    0 { Log-Message "Accounts Block Microsoft accounts:                  This policy is disabled" }
                    1 { Log-Message "Accounts Block Microsoft accounts:                  Users can't add Microsoft accounts" }
                    3 { Log-Message "Accounts Block Microsoft accounts:                  Users can't add or log on with Microsoft accounts" }
                    default { Log-Message "Accounts Block Microsoft accounts:                  Unknown value ($($currentValue.$registryName))" }
                }
            } else {
                Log-Message "Accounts Block Microsoft accounts:                  This policy is disabled (NoConnectedUser not set)"
            }
        } else {
            Log-Message "Accounts Block Microsoft accounts:                  This policy is disabled (Registry path not set)"
        }
    }
    catch {
        Log-Message "[ERROR] Failed to check registry value: $_"
    }



    secedit /export /cfg C:\secpol.cfg
    $defaultGuestAccountStatus = Select-String -Path C:\secpol.cfg -Pattern "EnableGuestAccount = (\d)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ($defaultGuestAccountStatus -eq "1") {
        Log-Message "Accounts Guest account status:                      Enabled"
    } else {
        Log-Message "Accounts Guest account status:                      Disabled (EnableGuestAccount not set or 0)"
    }
    Remove-Item -Path C:\secpol.cfg -Force



    secedit /export /cfg C:\secpol.cfg
    $defaultLimitBlankPasswordUse = Select-String -Path C:\secpol.cfg -Pattern "LimitBlankPasswordUse = (\d)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ($defaultLimitBlankPasswordUse -eq "0") {
        Log-Message "Accounts Limit local account use of blank passwords to console logon only:   Disabled"
    } else {
        Log-Message "Accounts Limit local account use of blank passwords to console logon only:   Enabled (LimitBlankPasswordUse not set or 1)"
    }
    Remove-Item -Path C:\secpol.cfg -Force



    secedit /export /cfg C:\secpol.cfg
    $updatedAdminName = Select-String -Path C:\secpol.cfg -Pattern 'NewAdministratorName = "(.*)"' | ForEach-Object { $_.Matches.Groups[1].Value }
    if ([string]::IsNullOrWhiteSpace($updatedAdminName)) {
        Log-Message "Accounts Rename administrator account:              Not set (NewAdministratorName not configured)"
    } else {
        Log-Message "Accounts Rename administrator account:              $updatedAdminName"
    }
    Remove-Item -Path C:\secpol.cfg -Force



    secedit /export /cfg C:\secpol.cfg
    $defaultGuestName = Select-String -Path C:\secpol.cfg -Pattern 'NewGuestName = "(.*)"' | ForEach-Object { $_.Matches.Groups[1].Value }
    if ([string]::IsNullOrWhiteSpace($defaultGuestName)) {
        Log-Message "Accounts Rename guest account:                      Not set (NewGuestName not configured)"
    } else {
        Log-Message "Accounts Rename guest account:                      $defaultGuestName"
    }
    Remove-Item -Path C:\secpol.cfg -Force



    $regPath = "HKLM:\System\CurrentControlSet\Control\Lsa"
    $regKey = "SCENoApplyLegacyAuditPolicy"
    $updatedAuditOverride = (Get-ItemProperty -Path $regPath -Name $regKey -ErrorAction SilentlyContinue).$regKey
    if ($updatedAuditOverride -eq 1) {
        Log-Message "Audit Force audit policy subcategory settings (Windows Vista or later) to override audit policy category settings:   Enabled"
    } else {
        Log-Message "Audit Force audit policy subcategory settings (Windows Vista or later) to override audit policy category settings:   Disabled (SCENoApplyLegacyAuditPolicy not set or 0)"
    }



    secedit /export /cfg C:\secpol.cfg
    $shutdownOnAuditFail = Select-String -Path C:\secpol.cfg -Pattern 'CrashOnAuditFail = (.*)' | ForEach-Object { $_.Matches.Groups[1].Value }
    if ([string]::IsNullOrWhiteSpace($shutdownOnAuditFail)) {
        Log-Message "Audit Shut down system immediately if unable to log security audits:   Disabled"
    } else {
        Log-Message "Audit Shut down system immediately if unable to log security audits:   $shutdownOnAuditFail"
    }
    Remove-Item -Path C:\secpol.cfg -Force



    $regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Print\Providers\LanMan Print Services\Servers"
    $regKey = "AddPrinterDrivers"
    $defaultPrinterDrivers = (Get-ItemProperty -Path $regPath -Name $regKey -ErrorAction SilentlyContinue).$regKey
    if ($defaultPrinterDrivers -eq "1") {
        Log-Message "Devices Prevent users from installing printer drivers:   Enabled"
    } else {
        Log-Message "Devices Prevent users from installing printer drivers:   Disabled (AddPrinterDrivers not set or 0)"
    }


    $regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters"
    $regKey = "RequireSignOrSeal"
    $defaultSecureChannel = (Get-ItemProperty -Path $regPath -Name $regKey -ErrorAction SilentlyContinue).$regKey
    if ($defaultSecureChannel -eq "1") {
        Log-Message "Domain member Digitally encrypt or sign secure channel data (always):   Enabled"
    } else {
        Log-Message "Domain member Digitally encrypt or sign secure channel data (always):   Disabled (RequireSignOrSeal not set or 0)"
    }


    $regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters"
    $regKey = "SealSecureChannel"
    $defaultSecureChannel = (Get-ItemProperty -Path $regPath -Name $regKey -ErrorAction SilentlyContinue).$regKey
    if ($defaultSecureChannel -eq "1") {
        Log-Message "Domain member Digitally encrypt secure channel data (when possible):   Enabled"
    } else {
        Log-Message "Domain member Digitally encrypt secure channel data (when possible):   Disabled (SealSecureChannel not set or 0)"
    }


    $regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters"
    $regKey = "SignSecureChannel"
    $defaultSignChannel = (Get-ItemProperty -Path $regPath -Name $regKey -ErrorAction SilentlyContinue).$regKey
    if ($defaultSignChannel -eq "1") {
        Log-Message "Domain member Digitally sign secure channel data (when possible):   Enabled"
    } else {
        Log-Message "Domain member Digitally sign secure channel data (when possible):   Disabled (SignSecureChannel not set or 0)"
    }



    Log-Message ""

    # Log the start of policy update
    Log-Message "--------------------------------------------------"
    Log-Message "        Applying Policy Updates..."
    Log-Message "--------------------------------------------------"

    Log-Message "[INFO] Setting Minimum Password Length to 14."
    net accounts /minpwlen:14

    Log-Message "[INFO] Setting Maximum Password Age to 365 days."
    net accounts /maxpwage:365

    Log-Message "[INFO] Setting Minimum Password Age to 1 day."
    net accounts /minpwage:1

    Log-Message "[INFO] Setting Password History Size to 24."
    net accounts /uniquepw:24

    Log-Message "[INFO] Setting Account Lockout Bad Count to 5."
    net accounts /lockout:5

    Log-Message "[INFO] Setting Account Lockout Duration to 15 minutes."
    net accounts /lockoutduration:15

    Log-Message "[INFO] Enabling Password Complexity..."
    $policyKey = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
    Set-ItemProperty -Path $policyKey -Name "PasswordComplexity" -Value 1

    Log-Message "[INFO] Applying Security Policy Changes..."
    secedit /export /cfg C:\secpol.cfg
    (Get-Content C:\secpol.cfg) -replace "PasswordComplexity = 0", "PasswordComplexity = 1" | Set-Content C:\secpol.cfg
    secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas SECURITYPOLICY
    Remove-Item -Path C:\secpol.cfg -Force

    Log-Message "[INFO] Password Complexity enabled."


    Log-Message "[INFO] Setting Account Lockout Threshold to 5 invalid attempts..."

    Log-Message "[INFO] Applying Security Policy Changes..."
    secedit /export /cfg C:\secpol.cfg
    (Get-Content C:\secpol.cfg) -replace "LockoutBadCount = \d+", "LockoutBadCount = 5" | Set-Content C:\secpol.cfg
    secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas SECURITYPOLICY
    Remove-Item -Path C:\secpol.cfg -Force

    Log-Message "[INFO] Account Lockout Threshold set to 5."


    Log-Message "[INFO] Disabling 'Store passwords using reversible encryption'..."
    secedit /export /cfg C:\secpol.cfg
    (Get-Content C:\secpol.cfg) -replace "ClearTextPassword = 1", "ClearTextPassword = 0" | Set-Content C:\secpol.cfg
    secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas SECURITYPOLICY
    Remove-Item -Path C:\secpol.cfg -Force
    Log-Message "[INFO] 'Store passwords using reversible encryption' disabled."


    Log-Message "[INFO] Enabling 'Allow Administrator account lockout'..."
    secedit /export /cfg C:\secpol.cfg
    (Get-Content C:\secpol.cfg) -replace "AllowAdministratorLockout = 0", "AllowAdministratorLockout = 1" | Set-Content C:\secpol.cfg
    secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas SECURITYPOLICY
    Remove-Item -Path C:\secpol.cfg -Force
    Log-Message "[INFO] 'Allow Administrator account lockout' enabled."


    Log-Message "[INFO] Setting 'Reset account lockout counter after' to 15 minutes..."
    secedit /export /cfg C:\secpol.cfg
    (Get-Content C:\secpol.cfg) -replace "ResetLockoutCount = \d+", "ResetLockoutCount = 15" | Set-Content C:\secpol.cfg
    secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas SECURITYPOLICY
    Remove-Item -Path C:\secpol.cfg -Force
    Log-Message "[INFO] 'Reset account lockout counter after' set to 15 minutes."


    Log-Message "[INFO] Setting 'Access Credential Manager as a trusted caller' to 'No One'..."
    secedit /export /cfg C:\secpol.cfg
    (Get-Content C:\secpol.cfg) -replace "SeTrustedCredManAccessPrivilege = .+", "SeTrustedCredManAccessPrivilege = " | Set-Content C:\secpol.cfg
    secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
    Remove-Item -Path C:\secpol.cfg -Force
    Log-Message "[INFO] 'Access Credential Manager as a trusted caller' set to 'No One'."


    Log-Message "[INFO] Setting 'Access this computer from the network' to 'Administrators, Remote Desktop Users'..."
    secedit /export /cfg C:\secpol.cfg
    (Get-Content C:\secpol.cfg) -replace "SeNetworkLogonRight = .+", "SeNetworkLogonRight = Administrators,Remote Desktop Users" | Set-Content C:\secpol.cfg
    secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
    Remove-Item -Path C:\secpol.cfg -Force
    Log-Message "[INFO] 'Access this computer from the network' set to 'Administrators, Remote Desktop Users'."


    Log-Message "[INFO] Setting 'Act as part of the operating system' to 'No One'..."
    secedit /export /cfg C:\secpol.cfg
    (Get-Content C:\secpol.cfg) -replace "SeTcbPrivilege = .+", "SeTcbPrivilege = " | Set-Content C:\secpol.cfg
    secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
    Remove-Item -Path C:\secpol.cfg -Force
    Log-Message "[INFO] 'Act as part of the operating system' set to 'No One'."


    Log-Message "[INFO] Setting 'Adjust memory quotas for a process' to 'Administrators, LOCAL SERVICE, NETWORK SERVICE'..."
    secedit /export /cfg C:\secpol.cfg
    (Get-Content C:\secpol.cfg) -replace "SeIncreaseQuotaPrivilege = .+", "SeIncreaseQuotaPrivilege = Administrators, LOCAL SERVICE, NETWORK SERVICE" | Set-Content C:\secpol.cfg
    secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
    Remove-Item -Path C:\secpol.cfg -Force
    Log-Message "[INFO] 'Adjust memory quotas for a process' set to 'Administrators, LOCAL SERVICE, NETWORK SERVICE'."


    Log-Message "[INFO] Setting 'Allow log on locally' to 'Administrators, Users'..."
    secedit /export /cfg C:\secpol.cfg
    (Get-Content C:\secpol.cfg) -replace "SeInteractiveLogonRight = .+", "SeInteractiveLogonRight = Administrators,Users" | Set-Content C:\secpol.cfg
    secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
    Remove-Item -Path C:\secpol.cfg -Force
    Log-Message "[INFO] 'Allow log on locally' set to 'Administrators, Users'."


    Log-Message "[INFO] Setting 'Allow log on through Remote Desktop Services' to 'Administrators, Remote Desktop Users'..."
    secedit /export /cfg C:\secpol.cfg
    (Get-Content C:\secpol.cfg) -replace "SeRemoteInteractiveLogonRight = .+", "SeRemoteInteractiveLogonRight = Administrators,Remote Desktop Users" | Set-Content C:\secpol.cfg
    secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
    Remove-Item -Path C:\secpol.cfg -Force
    Log-Message "[INFO] 'Allow log on through Remote Desktop Services' set to 'Administrators, Remote Desktop Users'."


    Log-Message "[INFO] Setting 'Back up files and directories' to 'Administrators'..."
    secedit /export /cfg C:\secpol.cfg
    (Get-Content C:\secpol.cfg) -replace "SeBackupPrivilege = .+", "SeBackupPrivilege = Administrators" | Set-Content C:\secpol.cfg
    secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
    Remove-Item -Path C:\secpol.cfg -Force
    Log-Message "[INFO] 'Back up files and directories' set to 'Administrators'."


    Log-Message "[INFO] Setting 'Change the system time' to 'Administrators, LOCAL SERVICE'..."
    secedit /export /cfg C:\secpol.cfg
    (Get-Content C:\secpol.cfg) -replace "SeTimeZonePrivilege = .+", "SeTimeZonePrivilege = Administrators, LOCAL SERVICE" | Set-Content C:\secpol.cfg
    secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
    Remove-Item -Path C:\secpol.cfg -Force
    Log-Message "[INFO] 'Change the system time' set to 'Administrators, LOCAL SERVICE'."


    Log-Message "[INFO] Setting 'Create a pagefile' to 'Administrators'..."
    secedit /export /cfg C:\secpol.cfg
    (Get-Content C:\secpol.cfg) -replace "SeCreatePagefilePrivilege = .+", "SeCreatePagefilePrivilege = Administrators" | Set-Content C:\secpol.cfg
    secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
    Remove-Item -Path C:\secpol.cfg -Force
    Log-Message "[INFO] 'Create a pagefile' set to 'Administrators'."


    Log-Message "[INFO] Setting 'Create a token object' to 'No One'..."
    secedit /export /cfg C:\secpol.cfg
    (Get-Content C:\secpol.cfg) -replace "SeCreateTokenPrivilege = .+", "SeCreateTokenPrivilege = " | Set-Content C:\secpol.cfg
    secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
    Remove-Item -Path C:\secpol.cfg -Force
    Log-Message "[INFO] 'Create a token object' set to 'No One'."


    Log-Message "[INFO] Setting 'Create global objects' to 'Administrators, LOCAL SERVICE, NETWORK SERVICE, SERVICE'..."
    secedit /export /cfg C:\secpol.cfg
    (Get-Content C:\secpol.cfg) -replace "SeCreateGlobalPrivilege = .+", "SeCreateGlobalPrivilege = *S-1-5-32-544,*S-1-5-19,*S-1-5-20,*S-1-5-6" | Set-Content C:\secpol.cfg
    secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
    Remove-Item -Path C:\secpol.cfg -Force
    Log-Message "[INFO] 'Create global objects' set to 'Administrators, LOCAL SERVICE, NETWORK SERVICE, SERVICE'."


    Log-Message "[INFO] Setting 'Create permanent shared objects' to 'No One'..."
    secedit /export /cfg C:\secpol.cfg
    (Get-Content C:\secpol.cfg) -replace "SeCreatePermanentPrivilege = .+", "SeCreatePermanentPrivilege = " | Set-Content C:\secpol.cfg
    secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
    Remove-Item -Path C:\secpol.cfg -Force
    Log-Message "[INFO] 'Create permanent shared objects' set to 'No One'."


    Log-Message "[INFO] Setting 'Create symbolic links' to 'Administrators, NT VIRTUAL MACHINE\\Virtual Machines'..."
    secedit /export /cfg C:\secpol.cfg
    (Get-Content C:\secpol.cfg) -replace "SeCreateSymbolicLinkPrivilege = .+", "SeCreateSymbolicLinkPrivilege = *S-1-5-32-544,*S-1-5-83-0" | Set-Content C:\secpol.cfg
    secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
    Remove-Item -Path C:\secpol.cfg -Force
    Log-Message "[INFO] 'Create symbolic links' set to 'Administrators, NT VIRTUAL MACHINE\\Virtual Machines'."


    Log-Message "[INFO] Setting 'Debug programs' to 'Administrators'..."
    secedit /export /cfg C:\secpol.cfg
    (Get-Content C:\secpol.cfg) -replace "SeDebugPrivilege = .+", "SeDebugPrivilege = *S-1-5-32-544" | Set-Content C:\secpol.cfg
    secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
    Remove-Item -Path C:\secpol.cfg -Force
    Log-Message "[INFO] 'Debug programs' set to 'Administrators'."


    Log-Message "[INFO] Setting 'Deny access to this computer from the network' to 'Guests, Local account'..."
    secedit /export /cfg C:\secpol.cfg
    (Get-Content C:\secpol.cfg) -replace "SeDenyNetworkLogonRight = .+", "SeDenyNetworkLogonRight = *S-1-5-32-546,*S-1-5-113" | Set-Content C:\secpol.cfg
    secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
    Remove-Item -Path C:\secpol.cfg -Force
    Log-Message "[INFO] 'Deny access to this computer from the network' set to 'Guests, Local account'."


    Log-Message "[INFO] Setting 'Deny log on as a batch job' to include 'Guests'..."
    secedit /export /cfg C:\secpol.cfg
    (Get-Content C:\secpol.cfg -Encoding Unicode) -replace "\[Privilege Rights\]", "[Privilege Rights]`nSeDenyBatchLogonRight = *S-1-5-32-546" | Set-Content C:\secpol.cfg -Encoding Unicode
    secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
    Remove-Item -Path C:\secpol.cfg -Force
    Log-Message "[INFO] 'Deny log on as a batch job' set to 'Guests'."


    Log-Message "[INFO] Setting 'Deny log on as a service' to include 'Guests'..."
    secedit /export /cfg C:\secpol.cfg
    (Get-Content C:\secpol.cfg -Encoding Unicode) -replace "\[Privilege Rights\]", "[Privilege Rights]`nSeDenyServiceLogonRight = *S-1-5-32-546" | Set-Content C:\secpol.cfg -Encoding Unicode
    secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
    Remove-Item -Path C:\secpol.cfg -Force
    Log-Message "[INFO] 'Deny log on as a service' set to 'Guests'."


    Log-Message "[INFO] Setting 'Deny log on locally' to include 'Guests'..."
    secedit /export /cfg C:\secpol.cfg
    (Get-Content C:\secpol.cfg -Encoding Unicode) -replace "\[Privilege Rights\]", "[Privilege Rights]`nSeDenyInteractiveLogonRight = *S-1-5-32-546" | Set-Content C:\secpol.cfg -Encoding Unicode
    secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
    Remove-Item -Path C:\secpol.cfg -Force
    Log-Message "[INFO] 'Deny log on locally' set to 'Guests'."


    Log-Message "[INFO] Setting 'Deny log on through Remote Desktop Services' to include 'Guests, Local account'..."
    secedit /export /cfg C:\secpol.cfg
    (Get-Content C:\secpol.cfg -Encoding Unicode) -replace "\[Privilege Rights\]", "[Privilege Rights]`nSeDenyRemoteInteractiveLogonRight = *S-1-5-32-546,*S-1-5-113" | Set-Content C:\secpol.cfg -Encoding Unicode
    secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
    Remove-Item -Path C:\secpol.cfg -Force
    Log-Message "[INFO] 'Deny log on through Remote Desktop Services' set to 'Guests, Local account'."


    Log-Message "[INFO] Setting 'Enable computer and user accounts to be trusted for delegation' to 'No One'..."
    secedit /export /cfg C:\secpol.cfg
    (Get-Content C:\secpol.cfg -Encoding Unicode) -replace "\[Privilege Rights\]", "[Privilege Rights]`nSeEnableDelegationPrivilege =" | Set-Content C:\secpol.cfg -Encoding Unicode
    secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
    Remove-Item -Path C:\secpol.cfg -Force
    Log-Message "[INFO] 'Enable computer and user accounts to be trusted for delegation' set to 'No One'."


    Log-Message "[INFO] Setting 'Force shutdown from a remote system' to 'Administrators'..."
    secedit /export /cfg C:\secpol.cfg
    (Get-Content C:\secpol.cfg) -replace "SeRemoteShutdownPrivilege\s*=.*", "SeRemoteShutdownPrivilege = *S-1-5-32-544" | Set-Content C:\secpol.cfg
    secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
    Remove-Item -Path C:\secpol.cfg -Force
    Log-Message "[INFO] 'Force shutdown from a remote system' set to 'Administrators'."


    Log-Message "[INFO] Setting 'Generate security audits' to 'LOCAL SERVICE, NETWORK SERVICE'..."
    secedit /export /cfg C:\secpol.cfg
    (Get-Content C:\secpol.cfg) -replace "SeAuditPrivilege = .+", "SeAuditPrivilege = *S-1-5-19,*S-1-5-20" | Set-Content C:\secpol.cfg
    secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
    Remove-Item -Path C:\secpol.cfg -Force
    Log-Message "[INFO] 'Generate security audits' set to 'LOCAL SERVICE, NETWORK SERVICE'."


    Log-Message "[INFO] Setting 'Impersonate a client after authentication' to 'Administrators, LOCAL SERVICE, NETWORK SERVICE, SERVICE'..."
    secedit /export /cfg C:\secpol.cfg
    (Get-Content C:\secpol.cfg) -replace "SeImpersonatePrivilege = .+", "SeImpersonatePrivilege = *S-1-5-32-544,*S-1-5-19,*S-1-5-20,*S-1-5-6" | Set-Content C:\secpol.cfg
    secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
    Remove-Item -Path C:\secpol.cfg -Force
    Log-Message "[INFO] 'Impersonate a client after authentication' set to 'Administrators, LOCAL SERVICE, NETWORK SERVICE, SERVICE'."


    Log-Message "[INFO] Setting 'Increase scheduling priority' to 'Administrators, Window Manager\Window Manager Group'..."
    secedit /export /cfg C:\secpol.cfg
    (Get-Content C:\secpol.cfg) -replace "SeIncreaseBasePriorityPrivilege = .+", "SeIncreaseBasePriorityPrivilege = *S-1-5-32-544,*S-1-5-90-0" | Set-Content C:\secpol.cfg
    secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
    Remove-Item -Path C:\secpol.cfg -Force
    Log-Message "[INFO] 'Increase scheduling priority' set to 'Administrators, Window Manager\Window Manager Group'."


    Log-Message "[INFO] Setting 'Load and unload device drivers' to 'Administrators'..."
    secedit /export /cfg C:\secpol.cfg
    (Get-Content C:\secpol.cfg) -replace "SeLoadDriverPrivilege = .+", "SeLoadDriverPrivilege = *S-1-5-32-544" | Set-Content C:\secpol.cfg
    secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
    Remove-Item -Path C:\secpol.cfg -Force
    Log-Message "[INFO] 'Load and unload device drivers' set to 'Administrators'."


    Log-Message "[INFO] Setting 'Lock pages in memory' to 'No One'..."
    secedit /export /cfg C:\secpol.cfg
    (Get-Content C:\secpol.cfg) -replace "SeLockMemoryPrivilege = .+", "SeLockMemoryPrivilege =" | Set-Content C:\secpol.cfg
    secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
    Remove-Item -Path C:\secpol.cfg -Force
    Log-Message "[INFO] 'Lock pages in memory' set to 'No One'."


    Log-Message "[INFO] Setting 'Log on as a batch job' to 'Administrators'..."
    secedit /export /cfg C:\secpol.cfg
    (Get-Content C:\secpol.cfg) -replace "SeBatchLogonRight = .+", "SeBatchLogonRight = *S-1-5-32-544" | Set-Content C:\secpol.cfg
    secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
    Remove-Item -Path C:\secpol.cfg -Force
    Log-Message "[INFO] 'Log on as a batch job' set to 'Administrators'."


    Log-Message "[INFO] Setting 'Log on as a service' to 'No One'..."
    secedit /export /cfg C:\secpol.cfg
    (Get-Content C:\secpol.cfg) -replace "SeServiceLogonRight = .+", "SeServiceLogonRight =" | Set-Content C:\secpol.cfg
    secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
    Remove-Item -Path C:\secpol.cfg -Force
    Log-Message "[INFO] 'Log on as a service' set to 'No One'."


    Log-Message "[INFO] Setting 'Manage auditing and security log' to 'Administrators'..."
    secedit /export /cfg C:\secpol.cfg
    (Get-Content C:\secpol.cfg) -replace "SeSecurityPrivilege = .+", "SeSecurityPrivilege = *S-1-5-32-544" | Set-Content C:\secpol.cfg
    secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
    Remove-Item -Path C:\secpol.cfg -Force
    Log-Message "[INFO] 'Manage auditing and security log' set to 'Administrators'."


    Log-Message "[INFO] Setting 'Modify an object label' to 'No One'..."
    secedit /export /cfg C:\secpol.cfg
    (Get-Content C:\secpol.cfg) -replace "SeRelabelPrivilege = .+", "SeRelabelPrivilege =" | Set-Content C:\secpol.cfg
    secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
    Remove-Item -Path C:\secpol.cfg -Force
    Log-Message "[INFO] 'Modify an object label' set to 'No One'."


    Log-Message "[INFO] Setting 'Modify firmware environment values' to 'Administrators'..."
    secedit /export /cfg C:\secpol.cfg
    (Get-Content C:\secpol.cfg) -replace "SeSystemEnvironmentPrivilege = .+", "SeSystemEnvironmentPrivilege = *S-1-5-32-544" | Set-Content C:\secpol.cfg
    secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
    Remove-Item -Path C:\secpol.cfg -Force
    Log-Message "[INFO] 'Modify firmware environment values' set to 'Administrators'."


    Log-Message "[INFO] Setting 'Perform volume maintenance tasks' to 'Administrators'..."
    secedit /export /cfg C:\secpol.cfg
    (Get-Content C:\secpol.cfg) -replace "SeManageVolumePrivilege = .+", "SeManageVolumePrivilege = *S-1-5-32-544" | Set-Content C:\secpol.cfg
    secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
    Remove-Item -Path C:\secpol.cfg -Force
    Log-Message "[INFO] 'Perform volume maintenance tasks' set to 'Administrators'."


    Log-Message "[INFO] Setting 'Profile single process' to 'Administrators'..."
    secedit /export /cfg C:\secpol.cfg
    (Get-Content C:\secpol.cfg) -replace "SeProfileSingleProcessPrivilege = .+", "SeProfileSingleProcessPrivilege = *S-1-5-32-544" | Set-Content C:\secpol.cfg
    secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
    Remove-Item -Path C:\secpol.cfg -Force
    Log-Message "[INFO] 'Profile single process' set to 'Administrators'."  


    Log-Message "[INFO] Setting 'Profile system performance' to 'Administrators, NT SERVICE\WdiServiceHost'..."
    secedit /export /cfg C:\secpol.cfg
    (Get-Content C:\secpol.cfg) -replace "SeSystemProfilePrivilege = .+", "SeSystemProfilePrivilege = *S-1-5-32-544,*S-1-5-80-957508804-1769844475-2058900238-1732851564-3222347252" | Set-Content C:\secpol.cfg
    secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
    Remove-Item -Path C:\secpol.cfg -Force
    Log-Message "[INFO] 'Profile system performance' set to 'Administrators, NT SERVICE\WdiServiceHost'."


    Log-Message "[INFO] Setting 'Replace a process level token' to 'LOCAL SERVICE, NETWORK SERVICE'..."
    secedit /export /cfg C:\secpol.cfg
    (Get-Content C:\secpol.cfg) -replace "SeReplaceProcessLevelTokenPrivilege = .+", "SeReplaceProcessLevelTokenPrivilege = *S-1-5-19,*S-1-5-20" | Set-Content C:\secpol.cfg
    secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
    Remove-Item -Path C:\secpol.cfg -Force
    Log-Message "[INFO] 'Replace a process level token' set to 'LOCAL SERVICE, NETWORK SERVICE'."


    Log-Message "[INFO] Setting 'Restore files and directories' to 'Administrators'..."
    secedit /export /cfg C:\secpol.cfg
    (Get-Content C:\secpol.cfg) -replace "SeRestorePrivilege = .+", "SeRestorePrivilege = *S-1-5-32-544" | Set-Content C:\secpol.cfg
    secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
    Remove-Item -Path C:\secpol.cfg -Force
    Log-Message "[INFO] 'Restore files and directories' set to 'Administrators'."


    Log-Message "[INFO] Setting 'Shut down the system' to 'Administrators, Users'..."
    secedit /export /cfg C:\secpol.cfg
    (Get-Content C:\secpol.cfg) -replace "SeShutdownPrivilege = .+", "SeShutdownPrivilege = *S-1-5-32-544,*S-1-5-32-545" | Set-Content C:\secpol.cfg
    secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
    Remove-Item -Path C:\secpol.cfg -Force
    Log-Message "[INFO] 'Shut down the system' set to 'Administrators, Users'." 


    Log-Message "[INFO] Setting 'Take ownership of files or other objects' to 'Administrators'..."
    secedit /export /cfg C:\secpol.cfg
    (Get-Content C:\secpol.cfg) -replace "SeTakeOwnershipPrivilege = .+", "SeTakeOwnershipPrivilege = *S-1-5-32-544" | Set-Content C:\secpol.cfg
    secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
    Remove-Item -Path C:\secpol.cfg -Force
    Log-Message "[INFO] 'Take ownership of files or other objects' set to 'Administrators'."


    Log-Message "[INFO] Setting 'Accounts Block Microsoft accounts' to 'Users can't add or log on with Microsoft accounts'..."
    $registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
    $registryName = "NoConnectedUser"
    $registryValue = 3
    if ([string]::IsNullOrWhiteSpace($registryPath)) {
        Log-Message "[ERROR] Registry path is null or empty. Aborting operation."
        return
    }
    try {
        if (-not (Test-Path $registryPath)) {
            New-Item -Path $registryPath -Force -ErrorAction Stop | Out-Null
            Log-Message "[INFO] Created registry path: $registryPath"
        }
        Set-ItemProperty -Path $registryPath -Name $registryName -Value $registryValue -Type DWord -Force -ErrorAction Stop
        Log-Message "[INFO] 'Accounts Block Microsoft accounts' set to 'Users can't add or log on with Microsoft accounts'."
    }
    catch {
        Log-Message "[ERROR] Failed to set registry value: $_"
        return
    }



    Log-Message "[INFO] Setting 'Accounts Guest account status' to 'Disabled'..."
    secedit /export /cfg C:\secpol.cfg
    (Get-Content C:\secpol.cfg -Encoding Unicode) -replace "EnableGuestAccount = .+", "EnableGuestAccount = 0" | Set-Content C:\secpol.cfg -Encoding Unicode
    secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas SECURITYPOLICY
    Remove-Item -Path C:\secpol.cfg -Force
    Log-Message "[INFO] 'Accounts Guest account status' set to 'Disabled'."


    Log-Message "[INFO] Setting 'Accounts Limit local account use of blank passwords to console logon only' to 'Enabled'..."
    secedit /export /cfg C:\secpol.cfg
    (Get-Content C:\secpol.cfg -Encoding Unicode) -replace "LimitBlankPasswordUse = .+", "LimitBlankPasswordUse = 1" | Set-Content C:\secpol.cfg -Encoding Unicode
    secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas SECURITYPOLICY
    Remove-Item -Path C:\secpol.cfg -Force
    Log-Message "[INFO] 'Accounts Limit local account use of blank passwords to console logon only' set to 'Enabled'."


    Log-Message "[INFO] Setting 'Accounts Rename administrator account' to 'SecureAdmin'..."
    secedit /export /cfg C:\secpol.cfg
    (Get-Content C:\secpol.cfg -Encoding Unicode) -replace 'NewAdministratorName = .+', 'NewAdministratorName = "SecureAdmin"' | Set-Content C:\secpol.cfg -Encoding Unicode
    secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas SECURITYPOLICY
    Remove-Item -Path C:\secpol.cfg -Force
    Log-Message "[INFO] 'Accounts Rename administrator account' set to 'SecureAdmin'."


    Log-Message "[INFO] Setting 'Accounts Rename guest account' to 'SecureGuest'..."
    secedit /export /cfg C:\secpol.cfg
    (Get-Content C:\secpol.cfg -Encoding Unicode) -replace 'NewGuestName = .+', 'NewGuestName = "SecureGuest"' | Set-Content C:\secpol.cfg -Encoding Unicode
    secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas SECURITYPOLICY
    Remove-Item -Path C:\secpol.cfg -Force
    Log-Message "[INFO] 'Accounts Rename guest account' set to 'SecureGuest'."


    Log-Message "[INFO] Setting 'Audit Force audit policy subcategory settings (Windows Vista or later) to override audit policy category settings' to 'Enabled'..."
    $regPath = "HKLM:\System\CurrentControlSet\Control\Lsa"
    $regKey = "SCENoApplyLegacyAuditPolicy"
    Set-ItemProperty -Path $regPath -Name $regKey -Value 1 -Type DWord -Force
    Log-Message "[INFO] 'Audit Force audit policy subcategory settings (Windows Vista or later) to override audit policy category settings' set to 'Enabled'."


    Log-Message "[INFO] Setting 'Audit Shut down system immediately if unable to log security audits' to 'Disabled'..."
    secedit /export /cfg C:\secpol.cfg
    (Get-Content C:\secpol.cfg -Encoding Unicode) -replace 'CrashOnAuditFail = \d+', 'CrashOnAuditFail = 0' | Set-Content C:\secpol.cfg -Encoding Unicode
    secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas SECURITYPOLICY
    Remove-Item -Path C:\secpol.cfg -Force
    Log-Message "[INFO] 'Audit Shut down system immediately if unable to log security audits' set to 'Disabled'."


    Log-Message "[INFO] Setting 'Devices Prevent users from installing printer drivers' to 'Enabled'..."
    $regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Print\Providers\LanMan Print Services\Servers"
    $regKey = "AddPrinterDrivers"
    if (-not (Test-Path $regPath)) {
        New-Item -Path $regPath -Force | Out-Null
    }
    Set-ItemProperty -Path $regPath -Name $regKey -Value 1 -Type DWord
    Log-Message "[INFO] 'Devices Prevent users from installing printer drivers' set to 'Enabled'."


    Log-Message "[INFO] Setting 'Domain member Digitally encrypt or sign secure channel data (always)' to 'Enabled'..."
    $regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters"
    $regKey = "RequireSignOrSeal"
    if (-not (Test-Path $regPath)) {
        New-Item -Path $regPath -Force | Out-Null
    }
    Set-ItemProperty -Path $regPath -Name $regKey -Value 1 -Type DWord
    Log-Message "[INFO] 'Domain member Digitally encrypt or sign secure channel data (always)' set to 'Enabled'."


    Log-Message "[INFO] Setting 'Domain member Digitally encrypt secure channel data (when possible)' to 'Enabled'..."
    $regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters"
    $regKey = "SealSecureChannel"
    if (-not (Test-Path $regPath)) {
        New-Item -Path $regPath -Force | Out-Null
    }
    Set-ItemProperty -Path $regPath -Name $regKey -Value 1 -Type DWord
    Log-Message "[INFO] 'Domain member Digitally encrypt secure channel data (when possible)' set to 'Enabled'."


    Log-Message "[INFO] Setting 'Domain member Digitally sign secure channel data (when possible)' to 'Enabled'..."
    $regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters"
    $regKey = "SignSecureChannel"
    if (-not (Test-Path $regPath)) {
        New-Item -Path $regPath -Force | Out-Null
    }
    Set-ItemProperty -Path $regPath -Name $regKey -Value 1 -Type DWord
    Log-Message "[INFO] 'Domain member Digitally sign secure channel data (when possible)' set to 'Enabled'."




    Log-Message ""
    Log-Message "[INFO] Account policies updated successfully."
    Log-Message ""

    # Log updated policy values
    Log-Message "--------------------------------------------------"
    Log-Message "          Updated Policies Values"
    Log-Message "--------------------------------------------------"

    $updatedPolicies = net accounts
    $updatedPolicies | ForEach-Object { 
        if ($_ -notmatch 'Lockout threshold|Lockout observation window') {
            Log-Message $_
        }
    }

    # Verify Password Complexity after update
    secedit /export /cfg C:\secpol.cfg
    $updatedComplexityStatus = Select-String -Path C:\secpol.cfg -Pattern "PasswordComplexity = (\d)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ($updatedComplexityStatus -eq "1") {
        Log-Message "Password Complexity:                                  Enabled"
    } else {
        Log-Message "Password Complexity:                                  Disabled"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $updatedLockoutThreshold = Select-String -Path C:\secpol.cfg -Pattern "LockoutBadCount = (\d+)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ($updatedLockoutThreshold -gt 0 -and $updatedLockoutThreshold -le 5) {
        Log-Message "Account Lockout Threshold:                            Enabled ($updatedLockoutThreshold)"
    } else {
        Log-Message "Account Lockout Threshold:                            Disabled or Not Set"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $updatedEncryptionStatus = Select-String -Path C:\secpol.cfg -Pattern "ClearTextPassword = (\d)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ($updatedEncryptionStatus -eq "0") {
        Log-Message "Store passwords using reversible encryption:          Disabled"
    } else {
        Log-Message "Store passwords using reversible encryption:          Enabled"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $updatedAdminLockoutStatus = Select-String -Path C:\secpol.cfg -Pattern "AllowAdministratorLockout = (\d)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ($updatedAdminLockoutStatus -eq "1") {
        Log-Message "Allow Administrator account lockout:                  Enabled"
    } else {
        Log-Message "Allow Administrator account lockout:                  Disabled"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $updatedLockoutCounter = Select-String -Path C:\secpol.cfg -Pattern "ResetLockoutCount = (\d+)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ($updatedLockoutCounter -ge 15) {
        Log-Message "Reset account lockout counter after:                  $updatedLockoutCounter minutes"
    } else {
        Log-Message "Reset account lockout counter after:                  Not Configured or Less than 15 minutes"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $updatedCredentialManager = Select-String -Path C:\secpol.cfg -Pattern "SeTrustedCredManAccessPrivilege = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ([string]::IsNullOrWhiteSpace($updatedCredentialManager)) {
        Log-Message "Access Credential Manager as a trusted caller:        No One"
    } else {
        Log-Message "Access Credential Manager as a trusted caller:        $updatedCredentialManager"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $updatedNetworkAccess = Select-String -Path C:\secpol.cfg -Pattern "SeNetworkLogonRight = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ($updatedNetworkAccess -match "Administrators,Remote Desktop Users") {
        Log-Message "Access this computer from the network:               Administrators, Remote Desktop Users"
    } else {
        Log-Message "Access this computer from the network:               $updatedNetworkAccess"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $updatedActAsSystem = Select-String -Path C:\secpol.cfg -Pattern "SeTcbPrivilege = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if (-not $updatedActAsSystem) {
        Log-Message "Act as part of the operating system:                  No One"
    } else {
        Log-Message "Act as part of the operating system:                  $updatedActAsSystem"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $updatedMemoryQuotas = Select-String -Path C:\secpol.cfg -Pattern "SeIncreaseQuotaPrivilege = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    Log-Message "Adjust memory quotas for a process:                  $updatedMemoryQuotas"
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $updatedLocalLogon = Select-String -Path C:\secpol.cfg -Pattern "SeInteractiveLogonRight = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ($updatedLocalLogon -match "Administrators,Users") {
        Log-Message "Allow log on locally:                                Administrators, Users"
    } else {
        Log-Message "Allow log on locally:                                $updatedLocalLogon"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $updatedRdpLogon = Select-String -Path C:\secpol.cfg -Pattern "SeRemoteInteractiveLogonRight = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ($updatedRdpLogon -match "Administrators,Remote Desktop Users") {
        Log-Message "Allow log on through Remote Desktop Services:        Administrators, Remote Desktop Users"
    } else {
        Log-Message "Allow log on through Remote Desktop Services:        $updatedRdpLogon"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $updatedBackupPrivilege = Select-String -Path C:\secpol.cfg -Pattern "SeBackupPrivilege = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ($updatedBackupPrivilege -match "Administrators") {
        Log-Message "Back up files and directories:                       Administrators"
    } else {
        Log-Message "Back up files and directories:                       $updatedBackupPrivilege"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $updatedTimePrivilege = Select-String -Path C:\secpol.cfg -Pattern "SeTimeZonePrivilege = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ($updatedTimePrivilege -match "Administrators, LOCAL SERVICE") {
        Log-Message "Change the system time:                              Administrators, LOCAL SERVICE"
    } else {
        Log-Message "Change the system time:                              $updatedTimePrivilege"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $updatedPagefilePrivilege = Select-String -Path C:\secpol.cfg -Pattern "SeCreatePagefilePrivilege = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ($updatedPagefilePrivilege -match "Administrators") {
        Log-Message "Create a pagefile:                                   Administrators"
    } else {
        Log-Message "Create a pagefile:                                   $updatedPagefilePrivilege"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $updatedTokenPrivilege = Select-String -Path C:\secpol.cfg -Pattern "SeCreateTokenPrivilege = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ([string]::IsNullOrWhiteSpace($updatedTokenPrivilege)) {
        Log-Message "Create a token object:                               No One"
    } else {
        Log-Message "Create a token object:                               $updatedTokenPrivilege"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $updatedGlobalPrivilege = Select-String -Path C:\secpol.cfg -Pattern "SeCreateGlobalPrivilege = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ([string]::IsNullOrWhiteSpace($updatedGlobalPrivilege)) {
        Log-Message "Create global objects:                               No One"
    } else {
        Log-Message "Create global objects:                               $updatedGlobalPrivilege"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $updatedPermanentPrivilege = Select-String -Path C:\secpol.cfg -Pattern "SeCreatePermanentPrivilege = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ([string]::IsNullOrWhiteSpace($updatedPermanentPrivilege)) {
        Log-Message "Create permanent shared objects:                     No One"
    } else {
        Log-Message "Create permanent shared objects:                     $updatedPermanentPrivilege"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $updatedSymbolicLinkPrivilege = Select-String -Path C:\secpol.cfg -Pattern "SeCreateSymbolicLinkPrivilege = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ([string]::IsNullOrWhiteSpace($updatedSymbolicLinkPrivilege)) {
        Log-Message "Create symbolic links:                               No One"
    } else {
        Log-Message "Create symbolic links:                               $updatedSymbolicLinkPrivilege"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $updatedDebugPrivilege = Select-String -Path C:\secpol.cfg -Pattern "SeDebugPrivilege = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ([string]::IsNullOrWhiteSpace($updatedDebugPrivilege)) {
        Log-Message "Debug programs:                                      No One"
    } else {
        Log-Message "Debug programs:                                      $updatedDebugPrivilege"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $updatedDenyNetwork = Select-String -Path C:\secpol.cfg -Pattern "SeDenyNetworkLogonRight = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ([string]::IsNullOrWhiteSpace($updatedDenyNetwork)) {
        Log-Message "Deny access to this computer from the network:       No One"
    } else {
        Log-Message "Deny access to this computer from the network:       $updatedDenyNetwork"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $updatedDenyBatch = Select-String -Path C:\secpol.cfg -Pattern "SeDenyBatchLogonRight = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ([string]::IsNullOrWhiteSpace($updatedDenyBatch)) {
        Log-Message "Deny log on as a batch job:                          No One"
    } else {
        Log-Message "Deny log on as a batch job:                          $updatedDenyBatch"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $updatedDenyService = Select-String -Path C:\secpol.cfg -Pattern "SeDenyServiceLogonRight = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ([string]::IsNullOrWhiteSpace($updatedDenyService)) {
        Log-Message "Deny log on as a service:                            No One"
    } else {
        Log-Message "Deny log on as a service:                            $updatedDenyService"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $updatedDenyInteractive = Select-String -Path C:\secpol.cfg -Pattern "SeDenyInteractiveLogonRight = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ([string]::IsNullOrWhiteSpace($updatedDenyInteractive)) {
        Log-Message "Deny log on locally:                                 No One"
    } else {
        Log-Message "Deny log on locally:                                 $updatedDenyInteractive"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $updatedDenyRDP = Select-String -Path C:\secpol.cfg -Pattern "SeDenyRemoteInteractiveLogonRight = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ([string]::IsNullOrWhiteSpace($updatedDenyRDP)) {
        Log-Message "Deny log on through Remote Desktop Services:         No One"
    } else {
        Log-Message "Deny log on through Remote Desktop Services:         $updatedDenyRDP"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $updatedDelegation = Select-String -Path C:\secpol.cfg -Pattern "SeEnableDelegationPrivilege = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ([string]::IsNullOrWhiteSpace($updatedDelegation)) {
        Log-Message "Enable computer and user accounts to be trusted for delegation:   No One"
    } else {
        Log-Message "Enable computer and user accounts to be trusted for delegation:   $updatedDelegation"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $shutdownSetting = Select-String -Path C:\secpol.cfg -Pattern "SeRemoteShutdownPrivilege\s*=\s*(.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ($shutdownSetting -match "S-1-5-32-544") {
        Log-Message "Force shutdown from a remote system:                 Administrators"
    } else {
        Log-Message "Force shutdown from a remote system:                 $shutdownSetting"
        }
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $updatedAudit = Select-String -Path C:\secpol.cfg -Pattern "SeAuditPrivilege = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ($updatedAudit -match "S-1-5-19" -and $updatedAudit -match "S-1-5-20") {
        Log-Message "Generate security audits:                            LOCAL SERVICE, NETWORK SERVICE"
    } elseif (-not [string]::IsNullOrWhiteSpace($updatedAudit)) {
        Log-Message "Generate security audits:                            $updatedAudit"
    } else {
        Log-Message "Generate security audits:                            Not configured"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $updatedImpersonate = Select-String -Path C:\secpol.cfg -Pattern "SeImpersonatePrivilege = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ([string]::IsNullOrWhiteSpace($updatedImpersonate)) {
        Log-Message "Impersonate a client after authentication:           No One"
    } else {
        Log-Message "Impersonate a client after authentication:           $updatedImpersonate"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $updatedPriority = Select-String -Path C:\secpol.cfg -Pattern "SeIncreaseBasePriorityPrivilege = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ([string]::IsNullOrWhiteSpace($updatedPriority)) {
        Log-Message "Increase scheduling priority:                        No One"
    } else {
        Log-Message "Increase scheduling priority:                        $updatedPriority"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $updatedDriverLoad = Select-String -Path C:\secpol.cfg -Pattern "SeLoadDriverPrivilege = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ([string]::IsNullOrWhiteSpace($updatedDriverLoad)) {
        Log-Message "Load and unload device drivers:                      No One"
    } else {
        Log-Message "Load and unload device drivers:                      $updatedDriverLoad"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $updatedLockPages = Select-String -Path C:\secpol.cfg -Pattern "SeLockMemoryPrivilege = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ([string]::IsNullOrWhiteSpace($updatedLockPages)) {
        Log-Message "Lock pages in memory:                                No One"
    } else {
        Log-Message "Lock pages in memory:                                $updatedLockPages"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $updatedBatchJob = Select-String -Path C:\secpol.cfg -Pattern "SeBatchLogonRight = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ([string]::IsNullOrWhiteSpace($updatedBatchJob)) {
        Log-Message "Log on as a batch job:                               Administrators"
    } else {
        Log-Message "Log on as a batch job:                               $updatedBatchJob"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $updatedServiceLogon = Select-String -Path C:\secpol.cfg -Pattern "SeServiceLogonRight = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ([string]::IsNullOrWhiteSpace($updatedServiceLogon)) {
        Log-Message "Log on as a service:                                 No One"
    } else {
        Log-Message "Log on as a service:                                 $updatedServiceLogon"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $updatedSecurityLog = Select-String -Path C:\secpol.cfg -Pattern "SeSecurityPrivilege = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ([string]::IsNullOrWhiteSpace($updatedSecurityLog)) {
        Log-Message "Manage auditing and security log:                    Administrators"
    } else {
        Log-Message "Manage auditing and security log:                    $updatedSecurityLog"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $updatedRelabel = Select-String -Path C:\secpol.cfg -Pattern "SeRelabelPrivilege = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ([string]::IsNullOrWhiteSpace($updatedRelabel)) {
        Log-Message "Modify an object label:                              No One"
    } else {
        Log-Message "Modify an object label:                              $updatedRelabel"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $updatedFirmwareEnv = Select-String -Path C:\secpol.cfg -Pattern "SeSystemEnvironmentPrivilege = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ([string]::IsNullOrWhiteSpace($updatedFirmwareEnv)) {
        Log-Message "Modify firmware environment values:                  Administrators"
    } else {
        Log-Message "Modify firmware environment values:                  $updatedFirmwareEnv"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $updatedVolumeTask = Select-String -Path C:\secpol.cfg -Pattern "SeManageVolumePrivilege = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ([string]::IsNullOrWhiteSpace($updatedVolumeTask)) {
        Log-Message "Perform volume maintenance tasks:                    Administrators"
    } else {
        Log-Message "Perform volume maintenance tasks:                    $updatedVolumeTask"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $updatedProfileProcess = Select-String -Path C:\secpol.cfg -Pattern "SeProfileSingleProcessPrivilege = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ([string]::IsNullOrWhiteSpace($updatedProfileProcess)) {
        Log-Message "Profile single process:                              Administrators"
    } else {
        Log-Message "Profile single process:                              $updatedProfileProcess"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $updatedSysPerf = Select-String -Path C:\secpol.cfg -Pattern "SeSystemProfilePrivilege = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ([string]::IsNullOrWhiteSpace($updatedSysPerf)) {
        Log-Message "Profile system performance:                          Administrators, NT SERVICE\WdiServiceHost"
    } else {
        Log-Message "Profile system performance:                          $updatedSysPerf"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $updatedReplaceProcessToken = Select-String -Path C:\secpol.cfg -Pattern "SeReplaceProcessLevelTokenPrivilege = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ([string]::IsNullOrWhiteSpace($updatedReplaceProcessToken)) {
        Log-Message "Replace a process level token:                       LOCAL SERVICE, NETWORK SERVICE"
    } else {
        Log-Message "Replace a process level token:                       $updatedReplaceProcessToken"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $updatedRestoreFiles = Select-String -Path C:\secpol.cfg -Pattern "SeRestorePrivilege = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ([string]::IsNullOrWhiteSpace($updatedRestoreFiles)) {
        Log-Message "Restore files and directories:                       Administrators"
    } else {
        Log-Message "Restore files and directories:                       $updatedRestoreFiles"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $updatedShutdownSystem = Select-String -Path C:\secpol.cfg -Pattern "SeShutdownPrivilege = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ([string]::IsNullOrWhiteSpace($updatedShutdownSystem)) {
        Log-Message "Shut down the system:                                Administrators, Users"
    } else {
        Log-Message "Shut down the system:                                $updatedShutdownSystem"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $updatedTakeOwnership = Select-String -Path C:\secpol.cfg -Pattern "SeTakeOwnershipPrivilege = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ([string]::IsNullOrWhiteSpace($updatedTakeOwnership)) {
        Log-Message "Take ownership of files or other objects:            Administrators"
    } else {
        Log-Message "Take ownership of files or other objects:            $updatedTakeOwnership"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $updatedBlockMicrosoftAccounts = Select-String -Path C:\secpol.cfg -Pattern "NoConnectedUser = (.*)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ([string]::IsNullOrWhiteSpace($updatedBlockMicrosoftAccounts)) {
        Log-Message "Accounts Block Microsoft accounts:                  Users can't add or log on with Microsoft accounts"
    } else {
        Log-Message "Accounts Block Microsoft accounts:                  $updatedBlockMicrosoftAccounts"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $defaultGuestAccountStatus = Select-String -Path C:\secpol.cfg -Pattern "EnableGuestAccount = (\d)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ($defaultGuestAccountStatus -eq "1") {
        Log-Message "Accounts Guest account status:                      Enabled"
    } else {
        Log-Message "Accounts Guest account status:                      Disabled (EnableGuestAccount not set or 0)"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $defaultLimitBlankPasswordUse = Select-String -Path C:\secpol.cfg -Pattern "LimitBlankPasswordUse = (\d)" | ForEach-Object { $_.Matches.Groups[1].Value }
    if ($defaultLimitBlankPasswordUse -eq "0") {
        Log-Message "Accounts Limit local account use of blank passwords to console logon only:   Disabled"
    } else {
        Log-Message "Accounts Limit local account use of blank passwords to console logon only:   Enabled (LimitBlankPasswordUse not set or 1)"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $updatedAdminName = Select-String -Path C:\secpol.cfg -Pattern 'NewAdministratorName = "(.*)"' | ForEach-Object { $_.Matches.Groups[1].Value }
    if ([string]::IsNullOrWhiteSpace($updatedAdminName)) {
        Log-Message "Accounts Rename administrator account:              Not set (NewAdministratorName not configured)"
    } else {
        Log-Message "Accounts Rename administrator account:              $updatedAdminName"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    secedit /export /cfg C:\secpol.cfg
    $updatedGuestName = Select-String -Path C:\secpol.cfg -Pattern 'NewGuestName = "(.*)"' | ForEach-Object { $_.Matches.Groups[1].Value }
    if ([string]::IsNullOrWhiteSpace($updatedGuestName)) {
        Log-Message "Accounts Rename guest account:                      Not set (NewGuestName not configured)"
    } else {
        Log-Message "Accounts Rename guest account:                      $updatedGuestName"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    $regPath = "HKLM:\System\CurrentControlSet\Control\Lsa"
    $regKey = "SCENoApplyLegacyAuditPolicy"
    $updatedAuditOverride = (Get-ItemProperty -Path $regPath -Name $regKey -ErrorAction SilentlyContinue).$regKey
    if ($updatedAuditOverride -eq 1) {
        Log-Message "Audit Force audit policy subcategory settings (Windows Vista or later) to override audit policy category settings:   Enabled"
    } else {
        Log-Message "Audit Force audit policy subcategory settings (Windows Vista or later) to override audit policy category settings:   Disabled (SCENoApplyLegacyAuditPolicy not set or 0)"
    }


    secedit /export /cfg C:\secpol.cfg
    $shutdownOnAuditFail = Select-String -Path C:\secpol.cfg -Pattern 'CrashOnAuditFail = (.*)' | ForEach-Object { $_.Matches.Groups[1].Value }
    if ([string]::IsNullOrWhiteSpace($shutdownOnAuditFail)) {
        Log-Message "Audit Shut down system immediately if unable to log security audits:   Disabled"
    } else {
        Log-Message "Audit Shut down system immediately if unable to log security audits:   $shutdownOnAuditFail"
    }
    Remove-Item -Path C:\secpol.cfg -Force


    $regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Print\Providers\LanMan Print Services\Servers"
    $regKey = "AddPrinterDrivers"
    $updatedPrinterDrivers = (Get-ItemProperty -Path $regPath -Name $regKey -ErrorAction SilentlyContinue).$regKey
    if ($updatedPrinterDrivers -eq "1") {
        Log-Message "Devices Prevent users from installing printer drivers:   Enabled"
    } else {
        Log-Message "Devices Prevent users from installing printer drivers:   Disabled (AddPrinterDrivers not set or 0)"
    }


    $regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters"
    $regKey = "RequireSignOrSeal"
    $updatedSecureChannel = (Get-ItemProperty -Path $regPath -Name $regKey -ErrorAction SilentlyContinue).$regKey
    if ($updatedSecureChannel -eq "1") {
        Log-Message "Domain member Digitally encrypt or sign secure channel data (always):   Enabled"
    } else {
        Log-Message "Domain member Digitally encrypt or sign secure channel data (always):   Disabled (RequireSignOrSeal not set or 0)"
    }


    $regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters"
    $regKey = "SealSecureChannel"
    $updatedSecureChannel = (Get-ItemProperty -Path $regPath -Name $regKey -ErrorAction SilentlyContinue).$regKey
    if ($updatedSecureChannel -eq "1") {
        Log-Message "Domain member Digitally encrypt secure channel data (when possible):   Enabled"
    } else {
        Log-Message "Domain member Digitally encrypt secure channel data (when possible):   Disabled (SealSecureChannel not set or 0)"
    }


    $regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters"
    $regKey = "SignSecureChannel"
    $updatedSignChannel = (Get-ItemProperty -Path $regPath -Name $regKey -ErrorAction SilentlyContinue).$regKey
    if ($updatedSignChannel -eq "1") {
        Log-Message "Domain member Digitally sign secure channel data (when possible):   Enabled"
    } else {
        Log-Message "Domain member Digitally sign secure channel data (when possible):   Disabled (SignSecureChannel not set or 0)"
    }



    # Apply policy changes immediately
    gpupdate /force
    Log-Message "[INFO] Group policy updated."
    
} catch {
    Log-Message "[ERROR] An error occurred: $_"
}

# Log script completion
Log-Message ""
Log-Message "[INFO] Policy update process completed."
Log-Message "=================================================="
