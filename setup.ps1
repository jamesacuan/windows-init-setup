#configure

# Sophos
$SNMP_host      = ''
$SNMP_community = 'wrkstn'

# Office dir
$Office365_dir  = ""
$Office2k7_dir  = ""

# WinUpdate Patch (KB3102810)
$WinUpdate_dir  = ""

# Citrix dir
$Citrix_dir     = ""

# company screensaver (if any)
$Scr_file       = ""

# checking processor architecture
if ((Get-WmiObject -Class Win32_ComputerSystem).SystemType -match ‘(x64)’ -eq 'True'){ $os_type='x64'}
else{ $os_type='x86' }

cls
do{
cls
Write-Host "
----------------------------------------------

   Setup
   
----------------------------------------------

  1. Configure for Sophos installation
  2. Apply Windows Update fix
  3. Setup and Install MS Office 2007/360
  4. Configure for remote setup
  5. Configure for Citrix
  6. Others
  
  [exit]
  
----------------------------------------------"
$option = Read-Host -Prompt 'Select option'

if($option -eq 1){
    do{
        cls
        Write-Host "
----------------------------------------------

   Configure for Sophos Installation
       
----------------------------------------------

   1. Setup and enable SNMP
   2. Enable Application Management service
   3. Enable Remote Registry service
   4. Enable Windows Installer service
   5. Disable Windows Firewall
   6. *Configure everything
   
   [back]
   
----------------------------------------------"
        $option = Read-Host -Prompt 'Select option: '
        
        # batch script equivalent
        #   net start nameofservice
        #   sc config nameofservice start=auto
        
        if($option -eq 1 -Or $option -eq 6){
            Write-Host "Setup SNMP..."
            ocsetup.exe SNMP /norestart /quiet
            reg add "HKLM\SYSTEM\CurrentControlSet\services\SNMP\Parameters\PermittedManagers" /f /v "1" /t REG_SZ /d "$SNMP_host"
            reg add "HKLM\SYSTEM\CurrentControlSet\services\SNMP\Parameters\ValidCommunities" /v "$SNMP_community" /t REG_DWORD /d 4 /f
        }
        
        if($option -eq 2 -Or $option -eq 6){
            Write-Host "Enable Application Management..."
            Start-Service AppMgmt
            Set-Service AppMgmt -startuptype "automatic"
        }
        
        if($option -eq 3 -Or $option -eq 6){
            Write-Host "Enable Remote Registry..."
            Start-Service RemoteRegistry
            Set-Service RemoteRegistry -startuptype "automatic"
        }

        if($option -eq 4 -Or $option -eq 6){
            Write-Host "Enable Windows Installer..."
            Start-Service msiserver
            Set-Service msiserver -startuptype "automatic"    
        }
        if($option -eq 5 -Or $option -eq 6){
            Write-Host "Disable Windows Firewall"
            NetSh Advfirewall set allprofiles state off
        }
    }until ($option -eq 'back')
    
}

elseif($option -eq 2){
    cls
    Write-Host "
----------------------------------------------

   Applying fixes for Windows Update
       
----------------------------------------------"
    if($os_type -eq 'x86'){
        $cmd = "wusa.exe " + $WinUpdate_dir + "\Windows6.1-KB3102810-x86.msu"
    }
    else{
        $cmd = "wusa.exe " + $WinUpdate_dir + "\Windows6.1-KB3102810-x64.msu"
    }
    Invoke-Expression -Command $cmd
    reg copy "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\_AU"
    reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
    Write-Host "Success!"
    Write-Host "Press any key to go back..."
}

elseif($option -eq 3){
    do{
        cls
        Write-Host "
----------------------------------------------

   MS Office Installation
       
----------------------------------------------

   1. Install Office 2007
   2. Install Office 365
   3. Remove Office 365
  
   [back]
   
----------------------------------------------"
        $option = Read-Host -Prompt 'Select option: '
        
        if($option -eq 1){
        
        }
        elseif($option -eq 2){
            Write-Host "Installing Office 365 (Please don't close this Window)"
            $cmd = "`"" + $Office365_dir + "`"\setup.exe /configure configuration.xml"
            Write-Host $cmd
            & $cmd

        }
        elseif($option -eq 3){
            Write-Host "Removing Office 365"
            Invoke-Expression $Office365_dir + "\o15-ctrremove.diagcab"
        }
    
    }until ($option -eq 'back')
}

elseif($option -eq 4){
    cls
    Write-Host "
----------------------------------------------

   Enabling Remote Desktop
       
----------------------------------------------"
    cls
    Write-Host "Enable Remote Desktop"
    reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f
    Write-Host "Success!"
    Write-Host "Press any key to go back..."
}

elseif($option -eq 5){
    cls
    Write-Host "Installing Citrix plugin"
    Invoke-Expression $Citrix_dir + "\CitrixOnlinePluginWeb.exe"
    reg copy "HKCR\PROTOCOLS\Filter\application/x-ica" "HKCR\PROTOCOLS\Filter\_application/x-ica"
    reg delete "HKCR\PROTOCOLS\Filter\application/x-ica"
}

elseif($option -eq 6){
    do{
        cls
        Write-Host "
----------------------------------------------

   Others
       
----------------------------------------------

   1. Disable Sleep mode (Power Options)
   2. Disable UAC
   3. Disable Aero for all users
   4. Disable Hibernate
   5. Install .scr
   6. Sync time with time server
   7. *Choose everything
  
   [back]
   
----------------------------------------------"
        $option = Read-Host -Prompt 'Select option: '
            if($option -eq 1 -Or $option -eq 7){
                Write-Host "Disabling Sleep Mode..."
                powercfg -change -monitor-timeout-ac 0
                powercfg -change -monitor-timeout-dc 0
                powercfg -change -standby-timeout-ac 0
                powercfg -change -standby-timeout-dc 0
            }
            if($option -eq 2 -Or $option -eq 7){
                Write-Host "Disabling UAC... (restart required)"
                reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableLUA" /t REG_DWORD /d 0 /f
            }
            if($option -eq 3 -Or $option -eq 7){
                Write-Host "Disabling Aero..."
                sc stop uxsms
            }
            if($option -eq 4 -Or $option -eq 7){
                Write-Host "Disabling Hibernate"
                powercfg.exe /hibernate off
            }
            if($option -eq 5 -Or $option -eq 7){
                Write-Host "Adding company screensaver"
                Invoke-Expression "copy "+ $Scr_file + " c:\Windows\System32"
            }
            if($option -eq 6 -Or $option -eq 7){
                Write-Host "Syncing with network time"
                w32tm /config /manualpeerlist:canada /syncfromflags:manual /update
            }
    }until ($option -eq 'back')
}

}until ($option -eq 'exit')
cls