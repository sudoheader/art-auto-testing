# ART-auto-testing
Let's define ART, Atomic Red Team.
Credits to https://github.com/redcanaryco/atomic-red-team

For information about the philosophy and development of Atomic Red Team, visit the website at https://atomicredteam.io

--- VTFoundation contribution ---
These scripts are developed to run Atomic Red Team testing automatically to test the controls. There are 2 components to it.
First, to install the `Invoke-AtomicTest` framework (https://github.com/redcanaryco/invoke-atomicredteam). You can do this manually or our script will do it for you.
Secondly, run the TIDs one by one manually or run ALL automated tests using our script.
## Getting Started:
The easiest way to start the automated Atomic Red Team tests are to run the following commands:
1. Run `PowerShell` as an admin and type this command.
``` powershell
Set-ExecutionPolicy RemoteSigned
```
2. Run `PowerShell` (whether you are admin or not) and type this command, which will install `Invoke-AtomicTest` framework and will ask you which TID to test or type ALL to run all TIDs.
``` powershell
curl https://raw.githubusercontent.com/VTFoundation/atomic-red-team/main/script-win.ps1 -o auto-ART.ps1; .\auto-ART.ps1
```
Decision-making during the script:
1. Is `Invoke-AtomicTest` framework installed?
2. Which TIDs to run (i.e. T1070) or ALL
3. Clean up
## ART.bat (Double-Click)
```powershell
curl https://raw.githubusercontent.com/VTFoundation/art-auto-testing/main/ART.bat -o ART.bat; .\ART.bat
```
#### Note: In this repo, check the `ART-win\scripts` folder for more information about the running process and which scripts to run manually, if needed.
