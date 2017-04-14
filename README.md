# windows-init-setup
script for configuring Windows in work environment.

- Setup for Sophos-client installation
- Configure and install Windows Update fix
- Configure and install MS Office 2007 or Office 365
- Configure Remote desktop
- Setup and install Citrix Online Plug-in (legacy)


## Dependencies
The script needed the following applications and should be placed in a shared directory.

1. [Update for Windows 7 (KB3102810)](https://www.microsoft.com/en-us/download/details.aspx?id=49542)
2. [Citrix Plugin](https://www.citrix.com/downloads/vdi-in-a-box/legacy-client-software/online-plug-in-for-windows-121.html)
3. Microsoft Office setup


## FAQ
#### PowerShell says “execution of scripts is disabled on this system.”
If you are trying to run .ps1 script for the first time, make sure to set the execution policy
```
Set-ExecutionPolicy RemoteSigned
```

#### Where is the Sophos client?
The script only prepares the system for Sophos client. Installation needs to be done from Sophos Management application from the server.


## To-Do
This was initially written in batch and in separate files. I'm still re-writing it and merged all in powershell and/or python.
