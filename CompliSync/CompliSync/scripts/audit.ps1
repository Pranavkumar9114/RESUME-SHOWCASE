$roamingAppData = [System.Environment]::GetFolderPath('ApplicationData')

# Define the app folder
$appFolder = Join-Path $roamingAppData "CompliSync"

# Define the Temp folder path
$tempFolder = Join-Path $appFolder "Temp"

# Define constants for log file path and temporary policy update file
$logFilePath = Join-Path $tempFolder "policy_update_log.txt"

$tempPolicyFilePath = Join-Path $tempFolder "temp_policy_update.json"

# Function to log messages with timestamp
function Log-Message {
    param (
        [string]$message
    )
    Add-Content -Path $logFilePath -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - $message"
}

# Create or clear the log file
if (-Not (Test-Path $logFilePath)) {
    New-Item -Path $logFilePath -ItemType File -Force
} else {
    Clear-Content -Path $logFilePath -Force
}

try {
    # Log script start
    Log-Message "=================================================="
    Log-Message "        Policy Update Log - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    Log-Message "=================================================="
    Log-Message ""

    # Check if a temporary policy update JSON file exists
    if (Test-Path $tempPolicyFilePath) {
        Log-Message "[INFO] Detected temporary policy update file."
        $policyUpdate = Get-Content -Path $tempPolicyFilePath | ConvertFrom-Json
        $policyName = $policyUpdate.policy_name
        $customValue = $policyUpdate.custom_value

        Log-Message "[INFO] Applying dynamic policy update for: $policyName with value: $customValue"

        # Dynamic policy application based on policy name
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
            default {
                Log-Message "[ERROR] Policy '$policyName' not recognized."
            }
        }

        # Apply policy changes immediately
        gpupdate /force
        Log-Message "[INFO] Group policy updated for $policyName."

        # Remove the temporary policy file after processing
        Remove-Item -Path $tempPolicyFilePath -Force
        Log-Message "[INFO] Temporary policy update file removed."

        # Log completion of dynamic update
        Log-Message "[INFO] Dynamic policy update completed for $policyName."
        Log-Message "=================================================="
        exit
    }

    # Original functionality if no temporary policy file exists
    Log-Message "--------------------------------------------------"
    Log-Message "          Default Policies Values"
    Log-Message "--------------------------------------------------"

    $currentPolicies = net accounts
    $currentPolicies | ForEach-Object { 
        if ($_ -notmatch 'Lockout threshold|Lockout observation window') {
            Log-Message $_
        }
    }

    # Check and log current Password Complexity setting
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
    net accounts /lockoutthreshold:5

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