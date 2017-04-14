cls

echo "----------------------------------------------"
echo "  Setup"
echo "----------------------------------------------"
echo "  1. Configure for Sophos installation"
echo "  2. Apply Windows Update fix"
echo "  3. Configure for Office 360 installation"
echo "  4. Configure for remote setup"
echo "  5. Configure for Citrix"
echo "----------------------------------------------"

$option = Read-Host -Prompt 'Select option: '
#Write-Host "You input server '$Server' and '$User' on '$Date'"

If($option -eq 1){
    cls
    echo "----------------------------------------------"
    echo "  Configure for Sophos Installation"
    echo "----------------------------------------------"
    echo "  1. Setup and enable SNMP"
    echo "  2. Enable Application Management service"
    echo "  3. Enable Remote Registry service"
    echo "  4. Enable Windows Installer service"
    echo "  5. Disable Windows Firewall"
    echo "  6. *Configure everything"
    echo "----------------------------------------------"
    $option = Read-Host -Prompt 'Select option: '
    
    if($option -eq 1 -Or $option -eq 6){
        echo "Setup SNMP..."
        ocsetup.exe SNMP /norestart /quiet
        reg add "HKLM\SYSTEM\CurrentControlSet\services\SNMP\Parameters\PermittedManagers" /f /v "1" /t REG_SZ /d "192.168.1.103"
        reg add "HKLM\SYSTEM\CurrentControlSet\services\SNMP\Parameters\ValidCommunities" /v "wrkstn" /t REG_DWORD /d 4 /f
    }
    
    if($option -eq 2 -Or $option -eq 6){
        echo "Enable Application Management..."
        net start AppMgmt
        sc config AppMgmt start=auto
    }
    
    if($option -eq 3 -Or $option -eq 6){
        echo "Enable Remote Registry..."
        net start RemoteRegistry
        sc config RemoteRegistry start=auto
    }

    if($option -eq 4 -Or $option -eq 6){
        echo "Enable Windows Installer..."
        net start msiserver
        sc config msiserver start=auto
    }
    if($option -eq 5 -Or $option -eq 6){
        echo "Disable Windows Firewall"
        NetSh Advfirewall set allprofiles state off
    }
}
ElseIf($option -eq 2){
    cls
    echo "Applying Windows Update fix"
    reg copy "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\_AU"
    reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
}
ElseIf($option -eq 3){
    cls
    echo "Installing Office 365..."
    \\ireland\Install\MS Office\Office 365 New\setup.exe /configure configuration.xml
}
ElseIf($option -eq 4){
    cls
    echo "Enable Remote Desktop"
    reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f
}