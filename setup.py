#!/usr/bin/python

import json, subprocess as sp

def has_admin():
    import os
    if os.name == 'nt':
        try:
            # only windows users with admin privileges can read the C:\windows\temp
            temp = os.listdir(os.sep.join([os.environ.get('SystemRoot','C:\\windows'),'temp']))
        except:
            return (os.environ['USERNAME'],False)
        else:
            return (os.environ['USERNAME'],True)
    else:
        if 'SUDO_USER' in os.environ and os.geteuid() == 0:
            return (os.environ['SUDO_USER'],True)
        else:
            return (os.environ['USERNAME'],False)

has_admin()

retry = True
#def check_permissions:
sp.call('echo Administrative permissions required. Detecting permissions...', shell=True)
sp.call('net session >nul 2>&1', shell=True)
sp.call('if %errorLevel% == 0 (', shell=True)
sp.call('echo Success: Administrative permissions confirmed.:', shell=True)
sp.call(' ) else (', shell=True)
sp.call('echo Failure: Current permissions inadequate.',shell=True)
sp.call(')');

# read config
with open('config.json', 'r') as f:
     settings = json.load(f)


while retry:

     print("----------------------------------------------\n")
     print("  1. Configure for Sophos installation")
     print("  2. Apply Windows Update fix")
     print("  3. Configure for Office 360 installation")
     print("  4. Configure for remote setup")
     print("\n----------------------------------------------\n")
     choice = input("Select option: ")

     if input("Play again? ") == "no":
          retry = False