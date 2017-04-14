#!/usr/bin/python

import json, subprocess as sp

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