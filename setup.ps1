#configure here
$SNMP_host      ='192.168.1.103'
$SNMP_community ='wrkstn'
$Office365_dir  ="\\ireland\install\MS Office\Office 365 New"
$Office2k7_dir  ="\\ireland\install\MS Office\MS Office 2007\Office 2007 Enterprise"
$WinUpdate_dir  ="\\ireland\install\Utilities\Update for Windows 7 (KB3102810)"
$Citrix_dir     ="\\ireland\install\3rd Party Softwares\Citrix\Citrix Web-Only Client"

#checking processor architecture
if ((Get-WmiObject -Class Win32_ComputerSystem).SystemType -match ‘(x64)’ -eq 'True'){
    $os_type='x64'
}
else{
    $os_type='x86'
}

cls

echo "----------------------------------------------"
echo "  Setup"
echo "----------------------------------------------"
echo "  1. Configure for Sophos installation"
echo "  2. Apply Windows Update fix"
echo "  3. Setup and Install MS Office 2007/360"
echo "  4. Configure for remote setup"
echo "  5. Configure for Citrix"
echo "  6. Others"
echo "----------------------------------------------"

$option = Read-Host -Prompt 'Select option: '

if($option -eq 1){
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
    
    # batch script equivalent
    #   net start nameofservice
    #   sc config nameofservice start=auto
    
    if($option -eq 1 -Or $option -eq 6){
        echo "Setup SNMP..."
        ocsetup.exe SNMP /norestart /quiet
        reg add "HKLM\SYSTEM\CurrentControlSet\services\SNMP\Parameters\PermittedManagers" /f /v "1" /t REG_SZ /d "$SNMP_host"
        reg add "HKLM\SYSTEM\CurrentControlSet\services\SNMP\Parameters\ValidCommunities" /v "$SNMP_community" /t REG_DWORD /d 4 /f
    }
    
    if($option -eq 2 -Or $option -eq 6){
        echo "Enable Application Management..."
        Start-Service AppMgmt
        Set-Service AppMgmt -startuptype "automatic"
    }
    
    if($option -eq 3 -Or $option -eq 6){
        echo "Enable Remote Registry..."
        Start-Service RemoteRegistry
        Set-Service RemoteRegistry -startuptype "automatic"
    }

    if($option -eq 4 -Or $option -eq 6){
        echo "Enable Windows Installer..."
        Start-Service msiserver
        Set-Service msiserver -startuptype "automatic"    
    }
    if($option -eq 5 -Or $option -eq 6){
        echo "Disable Windows Firewall"
        NetSh Advfirewall set allprofiles state off
    }
}
elseif($option -eq 2){
    cls
    echo "Applying Windows Update fix"
    if($os_type -eq 'x86'){
        $cmd = "wusa.exe " + $WinUpdate_dir + "\Windows6.1-KB3102810-x86.msu"
    }
    else{
        $cmd = "wusa.exe " + $WinUpdate_dir + "\Windows6.1-KB3102810-x64.msu"
    }
    Write-Host $cmd
    Invoke-Expression $cmd
    reg copy "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\_AU"
    reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
}
elseif($option -eq 3){
    cls
    echo "----------------------------------------------"
    echo "  Installing MS Office"
    echo "----------------------------------------------"
    echo "  1. Install Office 2007"
    echo "  2. Install Office 365"
    echo "  3. Remove Office 365"
    echo "----------------------------------------------"
    $option = Read-Host -Prompt 'Select option: '
    
    if($option -eq 1){
    
    }
    elseif($option -eq 2){
        echo "Installing Office 365 (Please don't close this Window)"
        $cmd = "`"" + $Office365_dir + "`"\setup.exe /configure configuration.xml"
        Write-Host $cmd
        & $cmd

    }
    elseif($option -eq 3){
        echo "Removing Office 365"
        Invoke-Expression $Office365_dir + "\o15-ctrremove.diagcab"
    }
}
elseif($option -eq 4){
    cls
    echo "Enable Remote Desktop"
    reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f
}

elseif($option -eq 5){
    cls
    echo "Installing Citrix plugin"
    Invoke-Expression $Citrix_dir + "\CitrixOnlinePluginWeb.exe"
    reg copy "HKCR\PROTOCOLS\Filter\application/x-ica" "HKCR\PROTOCOLS\Filter\_application/x-ica"
    reg delete "HKCR\PROTOCOLS\Filter\application/x-ica"
}
elseif($option -eq 6){
    cls
    echo "----------------------------------------------"
    echo "  Others"
    echo "----------------------------------------------"
    echo "  1. Disable Sleep mode (Power Options)"
    echo "  2. Disable UAC"
    echo "  3. *Choose everything"
    $option = Read-Host -Prompt 'Select option: '
        if($option -eq 1 -Or $option -eq 3){
            echo "Disabling Sleep Mode..."
            powercfg -change -monitor-timeout-ac 0
            powercfg -change -monitor-timeout-dc 0
            powercfg -change -standby-timeout-ac 0
            powercfg -change -standby-timeout-dc 0
        }
        elseif($option -eq 2 -Or $option -eq 3){
            echo "Disabling UAC... (restart required)"
            reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableLUA" /t REG_DWORD /d 0 /f
        }
}