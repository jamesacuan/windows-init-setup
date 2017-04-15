# windows-init-setup
script for configuring Windows in business environment.
 
- Apply fixes for Windows Update
- Configure Remote Desktop
- Configure system for Sophos-client
- Configure and install MS Office 365, Citrix Online Plugin
- and a few others


## Dependencies
The script needed the following applications and should be placed in a shared directory.

1. [Update for Windows 7 (KB3102810)](https://www.microsoft.com/en-us/download/details.aspx?id=49542)
2. [Citrix Plugin](https://www.citrix.com/downloads/vdi-in-a-box/legacy-client-software/online-plug-in-for-windows-121.html)
3. For deploying [MS Office 365](https://technet.microsoft.com/en-us/library/jj219423.aspx)

## FAQ
#### PowerShell says “execution of scripts is disabled on this system.”
Make sure to set the execution policy first.
```
Set-ExecutionPolicy RemoteSigned
```

#### Where is the Sophos client?
The script only prepares the system for Sophos client. Installation needs to be done from Sophos Management application from the server.

#### Some settings can be manage through Group Policy. You should have use that.
Ikr.

## To-Do
This was initially written in batch and in separate files. I'm still re-writing it and merged all in powershell