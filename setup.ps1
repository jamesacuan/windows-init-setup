cls
echo "----------------------------------------------"
echo "  1. Configure for Sophos installation"
echo "  2. Apply Windows Update fix"
echo "  3. Configure for Office 360 installation"
echo "  4. Configure for remote setup"
echo "----------------------------------------------"

$option = Read-Host -Prompt 'Select option: '
#Write-Host "You input server '$Server' and '$User' on '$Date'"

echo "STEP 1 of 5: Enabling SNMP..."
ocsetup.exe SNMP /norestart /quiet
reg add "HKLM\SYSTEM\CurrentControlSet\services\SNMP\Parameters\PermittedManagers" /f /v "1" /t REG_SZ /d "192.168.1.103"
reg add "HKLM\SYSTEM\CurrentControlSet\services\SNMP\Parameters\ValidCommunities" /v "wrkstn" /t REG_DWORD /d 4 /f

echo "STEP 2 of 5: Application Management..."
net start AppMgmt
sc config AppMgmt start= auto

echo "STEP 3 of 5: Remote Registry..."
net start RemoteRegistry
sc config RemoteRegistry start= auto

echo "STEP 4 of 5: Windows Installer..."
net start msiserver
sc config msiserver start= auto

echo "STEP 5 of 5: Turn off Windows Firewall"
NetSh Advfirewall set allprofiles state off

echo "STEP 6: enabling remote desktop"
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f
