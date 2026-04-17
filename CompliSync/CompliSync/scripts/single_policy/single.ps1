$roamingAppData = [System.Environment]::GetFolderPath('ApplicationData')

$appFolder = Join-Path $roamingAppData "CompliSync"

$tempFolder = Join-Path $appFolder "Temp"

$tempPolicyFilePath = Join-Path $tempFolder "temp_policy_update.json"

$logFilePath = Join-Path $tempFolder "single_policy_update_log.txt"

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
    
    if (Test-Path $tempPolicyFilePath) {
        Log-Message "[INFO] Detected temporary policy update file."
        $policyUpdate = Get-Content -Path $tempPolicyFilePath | ConvertFrom-Json
        $policyName = $policyUpdate.policy_name
        $customValue = $policyUpdate.custom_value

        Log-Message "[INFO] Applying dynamic policy update for: $policyName with value: $customValue"

        switch ($policyName) {
            "Minimum password length" {
                Log-Message "[INFO] Setting Minimum Password Length to $customValue."
                net accounts /minpwlen:$customValue
            }
            "Maximum password age (days)" {
                Log-Message "[INFO] Setting Maximum Password Age to $customValue days."
                net accounts /maxpwage:$customValue
            }
            "Minimum password age (days)" {
                Log-Message "[INFO] Setting Minimum Password Age to $customValue day."
                net accounts /minpwage:$customValue
            }
            "Length of password history maintained" {
                Log-Message "[INFO] Setting Password History Size to $customValue."
                net accounts /uniquepw:$customValue
            }
            "Lockout duration (minutes)" {
                Log-Message "[INFO] Setting Account Lockout Duration to $customValue minutes."
                net accounts /lockoutduration:$customValue
            }
            "Account Lockout Threshold" {
                $lockoutValue = if ($customValue -match "Enabled \((\d+)\)") { $matches[1] } else { $customValue }
                Log-Message "[INFO] Setting Account Lockout Threshold to $lockoutValue invalid attempts."
                net accounts /lockoutthreshold:$lockoutValue
            }
            "Password Complexity" {
                $complexityValue = if ($customValue -eq "Enabled") { 1 } else { 0 }
                Log-Message "[INFO] Setting Password Complexity to $customValue."
                secedit /export /cfg C:\secpol.cfg
                (Get-Content C:\secpol.cfg) -replace "PasswordComplexity = \d", "PasswordComplexity = $complexityValue" | Set-Content C:\secpol.cfg
                secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas SECURITYPOLICY
                Remove-Item -Path C:\secpol.cfg -Force
            }
            "Store passwords using reversible encryption" {
                $encryptionValue = if ($customValue -eq "Disabled") { 0 } else { 1 }
                Log-Message "[INFO] Setting 'Store passwords using reversible encryption' to $customValue."
                secedit /export /cfg C:\secpol.cfg
                (Get-Content C:\secpol.cfg) -replace "ClearTextPassword = \d", "ClearTextPassword = $encryptionValue" | Set-Content C:\secpol.cfg
                secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas SECURITYPOLICY
                Remove-Item -Path C:\secpol.cfg -Force
            }
            "Allow Administrator account lockout" {
                $adminLockoutValue = if ($customValue -eq "Enabled") { 1 } else { 0 }
                Log-Message "[INFO] Setting 'Allow Administrator account lockout' to $customValue."
                secedit /export /cfg C:\secpol.cfg
                (Get-Content C:\secpol.cfg) -replace "AllowAdministratorLockout = \d", "AllowAdministratorLockout = $adminLockoutValue" | Set-Content C:\secpol.cfg
                secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas SECURITYPOLICY
                Remove-Item -Path C:\secpol.cfg -Force
            }
            "Reset account lockout counter after" {
                $lockoutCounterValue = [int]($customValue -replace "[^\d]", "")
                Log-Message "[INFO] Setting 'Reset account lockout counter after' to $customValue."
                secedit /export /cfg C:\secpol.cfg
                (Get-Content C:\secpol.cfg) -replace "ResetLockoutCount = \d+", "ResetLockoutCount = $lockoutCounterValue" | Set-Content C:\secpol.cfg
                secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas SECURITYPOLICY
                Remove-Item -Path C:\secpol.cfg -Force
            }
            "Access Credential Manager as a trusted caller" {
                $credManagerValue = if ($customValue -eq "No One") { "" } else { $customValue }
                Log-Message "[INFO] Setting 'Access Credential Manager as a trusted caller' to $customValue."
                secedit /export /cfg C:\secpol.cfg
                (Get-Content C:\secpol.cfg) -replace "SeTrustedCredManAccessPrivilege = .+", "SeTrustedCredManAccessPrivilege = $credManagerValue" | Set-Content C:\secpol.cfg
                secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
                Remove-Item -Path C:\secpol.cfg -Force
            }
            "Access this computer from the network" {
                Log-Message "[INFO] Setting 'Access this computer from the network' to $customValue."
                secedit /export /cfg C:\secpol.cfg
                (Get-Content C:\secpol.cfg) -replace "SeNetworkLogonRight = .+", "SeNetworkLogonRight = $customValue" | Set-Content C:\secpol.cfg
                secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
                Remove-Item -Path C:\secpol.cfg -Force
            }
            "Act as part of the operating system" {
                $actAsSystemValue = if ($customValue -eq "No One") { "" } else { $customValue }
                Log-Message "[INFO] Setting 'Act as part of the operating system' to $customValue."
                secedit /export /cfg C:\secpol.cfg
                (Get-Content C:\secpol.cfg) -replace "SeTcbPrivilege = .+", "SeTcbPrivilege = $actAsSystemValue" | Set-Content C:\secpol.cfg
                secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
                Remove-Item -Path C:\secpol.cfg -Force
            }
            "Adjust memory quotas for a process" {
                Log-Message "[INFO] Setting 'Adjust memory quotas for a process' to $customValue."
                secedit /export /cfg C:\secpol.cfg
                (Get-Content C:\secpol.cfg) -replace "SeIncreaseQuotaPrivilege = .+", "SeIncreaseQuotaPrivilege = $customValue" | Set-Content C:\secpol.cfg
                secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
                Remove-Item -Path C:\secpol.cfg -Force
            }
            "Allow log on locally" {
                Log-Message "[INFO] Setting 'Allow log on locally' to $customValue."
                secedit /export /cfg C:\secpol.cfg
                (Get-Content C:\secpol.cfg) -replace "SeInteractiveLogonRight = .+", "SeInteractiveLogonRight = $customValue" | Set-Content C:\secpol.cfg
                secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
                Remove-Item -Path C:\secpol.cfg -Force
            }
            "Allow log on through Remote Desktop Services" {
                Log-Message "[INFO] Setting 'Allow log on through Remote Desktop Services' to $customValue."
                secedit /export /cfg C:\secpol.cfg
                (Get-Content C:\secpol.cfg) -replace "SeRemoteInteractiveLogonRight = .+", "SeRemoteInteractiveLogonRight = $customValue" | Set-Content C:\secpol.cfg
                secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
                Remove-Item -Path C:\secpol.cfg -Force
            }
            "Back up files and directories" {
                Log-Message "[INFO] Setting 'Back up files and directories' to $customValue."
                secedit /export /cfg C:\secpol.cfg
                (Get-Content C:\secpol.cfg) -replace "SeBackupPrivilege = .+", "SeBackupPrivilege = $customValue" | Set-Content C:\secpol.cfg
                secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
                Remove-Item -Path C:\secpol.cfg -Force
            }
            "Change the system time" {
                Log-Message "[INFO] Setting 'Change the system time' to $customValue."
                secedit /export /cfg C:\secpol.cfg
                (Get-Content C:\secpol.cfg) -replace "SeTimeZonePrivilege = .+", "SeTimeZonePrivilege = $customValue" | Set-Content C:\secpol.cfg
                secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
                Remove-Item -Path C:\secpol.cfg -Force
            }
            "Create a pagefile" {
                Log-Message "[INFO] Setting 'Create a pagefile' to $customValue."
                secedit /export /cfg C:\secpol.cfg
                (Get-Content C:\secpol.cfg) -replace "SeCreatePagefilePrivilege = .+", "SeCreatePagefilePrivilege = $customValue" | Set-Content C:\secpol.cfg
                secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
                Remove-Item -Path C:\secpol.cfg -Force
            }
            "Create a token object" {
                $tokenValue = if ($customValue -eq "No One") { "" } else { $customValue }
                Log-Message "[INFO] Setting 'Create a token object' to $customValue."
                secedit /export /cfg C:\secpol.cfg
                (Get-Content C:\secpol.cfg) -replace "SeCreateTokenPrivilege = .+", "SeCreateTokenPrivilege = $tokenValue" | Set-Content C:\secpol.cfg
                secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
                Remove-Item -Path C:\secpol.cfg -Force
            }
            "Create global objects" {
                $globalValue = if ($customValue -eq "No One") { "" } else { $customValue }
                Log-Message "[INFO] Setting 'Create global objects' to $customValue."
                secedit /export /cfg C:\secpol.cfg
                (Get-Content C:\secpol.cfg) -replace "SeCreateGlobalPrivilege = .+", "SeCreateGlobalPrivilege = $globalValue" | Set-Content C:\secpol.cfg
                secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
                Remove-Item -Path C:\secpol.cfg -Force
            }
            "Create permanent shared objects" {
                $permanentValue = if ($customValue -eq "No One") { "" } else { $customValue }
                Log-Message "[INFO] Setting 'Create permanent shared objects' to $customValue."
                secedit /export /cfg C:\secpol.cfg
                (Get-Content C:\secpol.cfg) -replace "SeCreatePermanentPrivilege = .+", "SeCreatePermanentPrivilege = $permanentValue" | Set-Content C:\secpol.cfg
                secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
                Remove-Item -Path C:\secpol.cfg -Force
            }
            "Create symbolic links" {
                Log-Message "[INFO] Setting 'Create symbolic links' to $customValue."
                secedit /export /cfg C:\secpol.cfg
                (Get-Content C:\secpol.cfg) -replace "SeCreateSymbolicLinkPrivilege = .+", "SeCreateSymbolicLinkPrivilege = $customValue" | Set-Content C:\secpol.cfg
                secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
                Remove-Item -Path C:\secpol.cfg -Force
            }
            "Debug programs" {
                Log-Message "[INFO] Setting 'Debug programs' to $customValue."
                secedit /export /cfg C:\secpol.cfg
                (Get-Content C:\secpol.cfg) -replace "SeDebugPrivilege = .+", "SeDebugPrivilege = $customValue" | Set-Content C:\secpol.cfg
                secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
                Remove-Item -Path C:\secpol.cfg -Force
            }
            "Deny access to this computer from the network" {
                $denyNetworkValue = if ($customValue -eq "No One") { "" } else { $customValue }
                Log-Message "[INFO] Setting 'Deny access to this computer from the network' to $customValue."
                secedit /export /cfg C:\secpol.cfg
                (Get-Content C:\secpol.cfg) -replace "SeDenyNetworkLogonRight = .+", "SeDenyNetworkLogonRight = $denyNetworkValue" | Set-Content C:\secpol.cfg
                secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
                Remove-Item -Path C:\secpol.cfg -Force
            }
            "Deny log on as a batch job" {
                $denyBatchValue = if ($customValue -eq "No One") { "" } else { $customValue }
                Log-Message "[INFO] Setting 'Deny log on as a batch job' to $customValue."
                secedit /export /cfg C:\secpol.cfg
                (Get-Content C:\secpol.cfg) -replace "SeDenyBatchLogonRight = .+", "SeDenyBatchLogonRight = $denyBatchValue" | Set-Content C:\secpol.cfg
                secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
                Remove-Item -Path C:\secpol.cfg -Force
            }
            "Deny log on as a service" {
                $denyServiceValue = if ($customValue -eq "No One") { "" } else { $customValue }
                Log-Message "[INFO] Setting 'Deny log on as a service' to $customValue."
                secedit /export /cfg C:\secpol.cfg
                (Get-Content C:\secpol.cfg) -replace "SeDenyServiceLogonRight = .+", "SeDenyServiceLogonRight = $denyServiceValue" | Set-Content C:\secpol.cfg
                secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
                Remove-Item -Path C:\secpol.cfg -Force
            }
            "Deny log on locally" {
                $denyLocalValue = if ($customValue -eq "No One") { "" } else { $customValue }
                Log-Message "[INFO] Setting 'Deny log on locally' to $customValue."
                secedit /export /cfg C:\secpol.cfg
                (Get-Content C:\secpol.cfg) -replace "SeDenyInteractiveLogonRight = .+", "SeDenyInteractiveLogonRight = $denyLocalValue" | Set-Content C:\secpol.cfg
                secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
                Remove-Item -Path C:\secpol.cfg -Force
            }
            "Deny log on through Remote Desktop Services" {
                $denyRdpValue = if ($customValue -eq "No One") { "" } else { $customValue }
                Log-Message "[INFO] Setting 'Deny log on through Remote Desktop Services' to $customValue."
                secedit /export /cfg C:\secpol.cfg
                (Get-Content C:\secpol.cfg) -replace "SeDenyRemoteInteractiveLogonRight = .+", "SeDenyRemoteInteractiveLogonRight = $denyRdpValue" | Set-Content C:\secpol.cfg
                secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
                Remove-Item -Path C:\secpol.cfg -Force
            }
            "Enable computer and user accounts to be trusted for delegation" {
                $delegationValue = if ($customValue -eq "No One") { "" } else { $customValue }
                Log-Message "[INFO] Setting 'Enable computer and user accounts to be trusted for delegation' to $customValue."
                secedit /export /cfg C:\secpol.cfg
                (Get-Content C:\secpol.cfg) -replace "SeEnableDelegationPrivilege = .+", "SeEnableDelegationPrivilege = $delegationValue" | Set-Content C:\secpol.cfg
                secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
                Remove-Item -Path C:\secpol.cfg -Force
            }
            "Force shutdown from a remote system" {
                Log-Message "[INFO] Setting 'Force shutdown from a remote system' to $customValue."
                secedit /export /cfg C:\secpol.cfg
                (Get-Content C:\secpol.cfg) -replace "SeRemoteShutdownPrivilege = .+", "SeRemoteShutdownPrivilege = $customValue" | Set-Content C:\secpol.cfg
                secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas  /areas USER_RIGHTS
                Remove-Item -Path C:\secpol.cfg -Force
            }
            "Generate security audits" {
                Log-Message "[INFO] Setting 'Generate security audits' to $customValue."
                secedit /export /cfg C:\secpol.cfg
                (Get-Content C:\secpol.cfg) -replace "SeAuditPrivilege = .+", "SeAuditPrivilege = $customValue" | Set-Content C:\secpol.cfg
                secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
                Remove-Item -Path C:\secpol.cfg -Force
            }
            "Impersonate a client after authentication" {
                Log-Message "[INFO] Setting 'Impersonate a client after authentication' to $customValue."
                secedit /export /cfg C:\secpol.cfg
                (Get-Content C:\secpol.cfg) -replace "SeImpersonatePrivilege = .+", "SeImpersonatePrivilege = $customValue" | Set-Content C:\secpol.cfg
                secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
                Remove-Item -Path C:\secpol.cfg -Force
            }
            "Increase scheduling priority" {
                Log-Message "[INFO] Setting 'Increase scheduling priority' to $customValue."
                secedit /export /cfg C:\secpol.cfg
                (Get-Content C:\secpol.cfg) -replace "SeIncreaseBasePriorityPrivilege = .+", "SeIncreaseBasePriorityPrivilege = $customValue" | Set-Content C:\secpol.cfg
                secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
                Remove-Item -Path C:\secpol.cfg -Force
            }
            "Load and unload device drivers" {
                Log-Message "[INFO] Setting 'Load and unload device drivers' to $customValue."
                secedit /export /cfg C:\secpol.cfg
                (Get-Content C:\secpol.cfg) -replace "SeLoadDriverPrivilege = .+", "SeLoadDriverPrivilege = $customValue" | Set-Content C:\secpol.cfg
                secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
                Remove-Item -Path C:\secpol.cfg -Force
            }
            "Lock pages in memory" {
                $lockPagesValue = if ($customValue -eq "No One") { "" } else { $customValue }
                Log-Message "[INFO] Setting 'Lock pages in memory' to $customValue."
                secedit /export /cfg C:\secpol.cfg
                (Get-Content C:\secpol.cfg) -replace "SeLockMemoryPrivilege = .+", "SeLockMemoryPrivilege = $lockPagesValue" | Set-Content C:\secpol.cfg
                secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
                Remove-Item -Path C:\secpol.cfg -Force
            }
            "Log on as a batch job" {
                Log-Message "[INFO] Setting 'Log on as a batch job' to $customValue."
                secedit /export /cfg C:\secpol.cfg
                (Get-Content C:\secpol.cfg) -replace "SeBatchLogonRight = .+", "SeBatchLogonRight = $customValue" | Set-Content C:\secpol.cfg
                secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
                Remove-Item -Path C:\secpol.cfg -Force
            }
            "Log on as a service" {
                $serviceLogonValue = if ($customValue -eq "No One") { "" } else { $customValue }
                Log-Message "[INFO] Setting 'Log on as a service' to $customValue."
                secedit /export /cfg C:\secpol.cfg
                (Get-Content C:\secpol.cfg) -replace "SeServiceLogonRight = .+", "SeServiceLogonRight = $serviceLogonValue" | Set-Content C:\secpol.cfg
                secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
                Remove-Item -Path C:\secpol.cfg -Force
            }
            "Manage auditing and security log" {
                Log-Message "[INFO] Setting 'Manage auditing and security log' to $customValue."
                secedit /export /cfg C:\secpol.cfg
                (Get-Content C:\secpol.cfg) -replace "SeSecurityPrivilege = .+", "SeSecurityPrivilege = $customValue" | Set-Content C:\secpol.cfg
                secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
                Remove-Item -Path C:\secpol.cfg -Force
            }
            "Modify an object label" {
                $relabelValue = if ($customValue -eq "No One") { "" } else { $customValue }
                Log-Message "[INFO] Setting 'Modify an object label' to $customValue."
                secedit /export /cfg C:\secpol.cfg
                (Get-Content C:\secpol.cfg) -replace "SeRelabelPrivilege = .+", "SeRelabelPrivilege = $relabelValue" | Set-Content C:\secpol.cfg
                secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
                Remove-Item -Path C:\secpol.cfg -Force
            }
            "Modify firmware environment values" {
                Log-Message "[INFO] Setting 'Modify firmware environment values' to $customValue."
                secedit /export /cfg C:\secpol.cfg
                (Get-Content C:\secpol.cfg) -replace "SeSystemEnvironmentPrivilege = .+", "SeSystemEnvironmentPrivilege = $customValue" | Set-Content C:\secpol.cfg
                secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
                Remove-Item -Path C:\secpol.cfg -Force
            }
            "Perform volume maintenance tasks" {
                Log-Message "[INFO] Setting 'Perform volume maintenance tasks' to $customValue."
                secedit /export /cfg C:\secpol.cfg
                (Get-Content C:\secpol.cfg) -replace "SeManageVolumePrivilege = .+", "SeManageVolumePrivilege = $customValue" | Set-Content C:\secpol.cfg
                secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
                Remove-Item -Path C:\secpol.cfg -Force
            }
            "Profile single process" {
                Log-Message "[INFO] Setting 'Profile single process' to $customValue."
                secedit /export /cfg C:\secpol.cfg
                (Get-Content C:\secpol.cfg) -replace "SeProfileSingleProcessPrivilege = .+", "SeProfileSingleProcessPrivilege = $customValue" | Set-Content C:\secpol.cfg
                secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
                Remove-Item -Path C:\secpol.cfg -Force
            }
            "Profile system performance" {
                Log-Message "[INFO] Setting 'Profile system performance' to $customValue."
                secedit /export /cfg C:\secpol.cfg
                (Get-Content C:\secpol.cfg) -replace "SeSystemProfilePrivilege = .+", "SeSystemProfilePrivilege = $customValue" | Set-Content C:\secpol.cfg
                secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
                Remove-Item -Path C:\secpol.cfg -Force
            }
            "Replace a process level token" {
                Log-Message "[INFO] Setting 'Replace a process level token' to $customValue."
                secedit /export /cfg C:\secpol.cfg
                (Get-Content C:\secpol.cfg) -replace "SeReplaceProcessLevelTokenPrivilege = .+", "SeReplaceProcessLevelTokenPrivilege = $customValue" | Set-Content C:\secpol.cfg
                secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
                Remove-Item -Path C:\secpol.cfg -Force
            }
            "Restore files and directories" {
                Log-Message "[INFO] Setting 'Restore files and directories' to $customValue."
                secedit /export /cfg C:\secpol.cfg
                (Get-Content C:\secpol.cfg) -replace "SeRestorePrivilege = .+", "SeRestorePrivilege = $customValue" | Set-Content C:\secpol.cfg
                secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
                Remove-Item -Path C:\secpol.cfg -Force
            }
            "Shut down the system" {
                Log-Message "[INFO] Setting 'Shut down the system' to $customValue."
                secedit /export /cfg C:\secpol.cfg
                (Get-Content C:\secpol.cfg) -replace "SeShutdownPrivilege = .+", "SeShutdownPrivilege = $customValue" | Set-Content C:\secpol.cfg
                secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
                Remove-Item -Path C:\secpol.cfg -Force
            }
            "Take ownership of files or other objects" {
                Log-Message "[INFO] Setting 'Take ownership of files or other objects' to $customValue."
                secedit /export /cfg C:\secpol.cfg
                (Get-Content C:\secpol.cfg) -replace "SeTakeOwnershipPrivilege = .+", "SeTakeOwnershipPrivilege = $customValue" | Set-Content C:\secpol.cfg
                secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas USER_RIGHTS
                Remove-Item -Path C:\secpol.cfg -Force
            }
            "Accounts: Block Microsoft accounts" {
                $registryValue = switch ($customValue) {
                    "This policy is disabled" { 0 }
                    "Users can't add Microsoft accounts" { 1 }
                    "Users can't add or log on with Microsoft accounts" { 3 }
                    default { throw "Invalid value for 'Accounts: Block Microsoft accounts': $customValue" }
                }
                Log-Message "[INFO] Setting 'Accounts: Block Microsoft accounts' to $customValue."
                $registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
                $registryName = "NoConnectedUser"
                if (-not (Test-Path $registryPath)) {
                    New-Item -Path $registryPath -Force | Out-Null
                }
                Set-ItemProperty -Path $registryPath -Name $registryName -Value $registryValue -Type DWord
            }
            "Accounts: Guest account status" {
                $guestAccountValue = if ($customValue -eq "Enabled") { 1 } else { 0 }
                Log-Message "[INFO] Setting 'Accounts: Guest account status' to $customValue."
                secedit /export /cfg C:\secpol.cfg
                (Get-Content C:\secpol.cfg) -replace "EnableGuestAccount = \d", "EnableGuestAccount = $guestAccountValue" | Set-Content C:\secpol.cfg
                secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas SECURITYPOLICY
                Remove-Item -Path C:\secpol.cfg -Force
            }
            "Accounts: Limit local account use of blank passwords to console logon only" {
                $blankPasswordValue = if ($customValue -eq "Enabled") { 1 } else { 0 }
                Log-Message "[INFO] Setting 'Accounts: Limit local account use of blank passwords to console logon only' to $customValue."
                secedit /export /cfg C:\secpol.cfg
                (Get-Content C:\secpol.cfg) -replace "LimitBlankPasswordUse = \d", "LimitBlankPasswordUse = $blankPasswordValue" | Set-Content C:\secpol.cfg
                secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas SECURITYPOLICY
                Remove-Item -Path C:\secpol.cfg -Force
            }
            "Accounts: Rename administrator account" {
                Log-Message "[INFO] Setting 'Accounts: Rename administrator account' to $customValue."
                secedit /export /cfg C:\secpol.cfg
                (Get-Content C:\secpol.cfg) -replace 'NewAdministratorName = ".+"', "NewAdministratorName = `"$customValue`"" | Set-Content C:\secpol.cfg
                secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas SECURITYPOLICY
                Remove-Item -Path C:\secpol.cfg -Force
            }
            "Accounts: Rename guest account" {
                Log-Message "[INFO] Setting 'Accounts: Rename guest account' to $customValue."
                secedit /export /cfg C:\secpol.cfg
                (Get-Content C:\secpol.cfg) -replace 'NewGuestName = ".+"', "NewGuestName = `"$customValue`"" | Set-Content C:\secpol.cfg
                secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas SECURITYPOLICY
                Remove-Item -Path C:\secpol.cfg -Force
            }
            "Audit: Force audit policy subcategory settings (Windows Vista or later) to override audit policy category settings" {
                $auditOverrideValue = if ($customValue -eq "Enabled") { 1 } else { 0 }
                Log-Message "[INFO] Setting 'Audit: Force audit policy subcategory settings (Windows Vista or later) to override audit policy category settings' to $customValue."
                $regPath = "HKLM:\System\CurrentControlSet\Control\Lsa"
                $regKey = "SCENoApplyLegacyAuditPolicy"
                Set-ItemProperty -Path $regPath -Name $regKey -Value $auditOverrideValue -Type DWord
            }
            "Audit: Shut down system immediately if unable to log security audits" {
                $crashOnAuditFailValue = if ($customValue -eq "Enabled") { 1 } else { 0 }
                Log-Message "[INFO] Setting 'Audit: Shut down system immediately if unable to log security audits' to $customValue."
                secedit /export /cfg C:\secpol.cfg
                (Get-Content C:\secpol.cfg) -replace "CrashOnAuditFail = \d", "CrashOnAuditFail = $crashOnAuditFailValue" | Set-Content C:\secpol.cfg
                secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas SECURITYPOLICY
                Remove-Item -Path C:\secpol.cfg -Force
            }
            "Devices: Prevent users from installing printer drivers" {
                $printerDriversValue = if ($customValue -eq "Enabled") { 1 } else { 0 }
                Log-Message "[INFO] Setting 'Devices: Prevent users from installing printer drivers' to $customValue."
                $regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Print\Providers\LanMan Print Services\Servers"
                $regKey = "AddPrinterDrivers"
                if (-not (Test-Path $regPath)) {
                    New-Item -Path $regPath -Force | Out-Null
                }
                Set-ItemProperty -Path $regPath -Name $regKey -Value $printerDriversValue -Type DWord
            }
            "Domain member: Digitally encrypt or sign secure channel data (always)" {
                $secureChannelValue = if ($customValue -eq "Enabled") { 1 } else { 0 }
                Log-Message "[INFO] Setting 'Domain member: Digitally encrypt or sign secure channel data (always)' to $customValue."
                $regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters"
                $regKey = "RequireSignOrSeal"
                if (-not (Test-Path $regPath)) {
                    New-Item -Path $regPath -Force | Out-Null
                }
                Set-ItemProperty -Path $regPath -Name $regKey -Value $secureChannelValue -Type DWord
            }
            "Domain member Digitally encrypt secure channel data (when possible)" {
                $encryptChannelValue = if ($customValue -eq "Enabled") { 1 } else { 0 }
                Log-Message "[INFO] Setting 'Domain member: Digitally encrypt secure channel data (when possible)' to $customValue."
                $regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters"
                $regKey = "SealSecureChannel"
                if (-not (Test-Path $regPath)) {
                    New-Item -Path $regPath -Force | Out-Null
                }
                Set-ItemProperty -Path $regPath -Name $regKey -Value $encryptChannelValue -Type DWord
            }
            "Domain member Digitally sign secure channel data (when possible)" {
                $signChannelValue = if ($customValue -eq "Enabled") { 1 } else { 0 }
                Log-Message "[INFO] Setting 'Domain member: Digitally sign secure channel data (when possible)' to $customValue."
                $regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters"
                $regKey = "SignSecureChannel"
                if (-not (Test-Path $regPath)) {
                    New-Item -Path $regPath -Force | Out-Null
                }
                Set-ItemProperty -Path $regPath -Name $regKey -Value $signChannelValue -Type DWord
            }
            default {
                Log-Message "[ERROR] Policy '$policyName' not recognized."
            }
        }

        gpupdate /force
        Log-Message "[INFO] Group policy updated for $policyName."

        Log-Message "[INFO] Dynamic policy update completed for $policyName."
        Log-Message "=================================================="
        exit
    }
} catch {
    Log-Message "[ERROR] An error occurred: $_"
}

# Log script completion
Log-Message ""
Log-Message "[INFO] Policy update process completed."
Log-Message "=================================================="
