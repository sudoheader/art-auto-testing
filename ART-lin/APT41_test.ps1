# APT41_test.ps1 for Linux

# Linux ART
# Credits to https://github.com/redcanaryco/atomic-red-team and @anantkaul
# Created by @sudoheader
# """"""""""""""""""""""""""""""""""""""
# !!!!! WARNING: RUN ON LINUX ONLY !!!!!
# """"""""""""""""""""""""""""""""""""""

# Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope CurrentUser -Force

# Checking Invoke-Atomic Framework
if (-not (Test-Path -Path $env:HOME + "AtomicRedTeam/invoke-atomicredteam")) {
   Write-Output "`n >> Installing Invoke-Atomic Framework ...`n"
   Install-Module -Name invoke-atomicredteam,powershell-yaml -Scope CurrentUser -Force
   Write-Output "`n >> Installed Invoke-Atomic Framework successfully ..." | green
}
# Checking the atomics
if (-not (Test-Path -Path $env:HOME + " AtomicRedTeam/atomic")) {
   Write-Output "`n >> Getting the atomics ...`n"
   Invoke-Expression (Invoke-WebRequest 'https://raw.githubusercontent.com/redcanaryco/invoke-atomicredteam/master/install-atomicredteam.ps1' -UseBasicParsing); Install-AtomicRedTeam -getAtomics -Force
   # Importing the module
   Import-Module $env:HOME + "AtomicRedTeam/invoke-atomicredteam/Invoke-AtomicRedTeam.psd1" -Force
   Write-Output " >> Successfully Installed `"Atomic-Red-Team`" in `"$env:HOME + AtomicRedTeam/`" ..." | green
   Read-Host -Prompt "`n >> Press enter to continue"
}

## Change Technique IDs and TestNumbers in the format 'T1003 -TestNumbers 1,2,3', ....
$apt41 = @(('T1071.001', 3),
            ('T1560.001' 5),
            ('T1560.001' 6),
            ('T1560.001' 7),
            ('T1560.001' 8),
            ('T1594.004' 1),
            ('T1594.004' 2),
            ('T1594.004' 3),
            ('T1594.004' 4),
            ('T1136.001' 1),
            ('T1136.001' 5),
            ('T1486' 1),
            ('T1486' 2),
            ('T1486' 3),
            ('T1486' 4),
            ('T1083' 3),
            ('T1083' 4),
            ('T1574.006' 1),
            ('T1574.006' 2),
            ('T1070.003' 1),
            ('T1070.003' 2),
            ('T1070.003' 3),
            ('T1070.003' 4),
            ('T1070.003' 5),
            ('T1070.003' 6),
            ('T1070.003' 7),
            ('T1070.003' 8),
            ('T1070.003' 9),
            ('T1070.004' 1),
            ('T1070.004' 2),
            ('T1070.004' 3),
            #('T1070.004' 8), Deletes Filesystem for Linux, skipping
            ('T1105', 1),
            ('T1105', 2),
            ('T1105', 3),
            ('T1105', 4),
            ('T1105', 5),
            ('T1105', 6),
            ('T1105', 14),
            ('T1135', 2),
            #('T1588'), No Atomic test number, skipping
            #('T1588.002'), No Atomic test number, skipping
            ('T1496', 1),
            ('T1014', 1),
            ('T1014', 2),
            ('T1569.002', 3))

$c = 0

foreach ($tid in $apt41) {

   try {
      $date_time = Get-Date -Format "MM:dd:yyyy_HH:mm"
      $date_time = $date_time.Replace(':', "-")
      Write-Output "[!!!!!!!! BEGIN ATOMIC TEST TID-$tid at $date_time !!!!!!!]" | yellow
      Invoke-AtomicTest $apt41[$c][0] -TestNumbers $apt41[$c][1] -ShowDetailsBrief
      Invoke-AtomicTest $apt41[$c][0] -TestNumbers $apt41[$c][1] -ShowDetails

      # Try installing the dependencies first ...
      Invoke-AtomicTest $apt41[$c][0] -TestNumbers $apt41[$c][1] -GetPrereqs -Force
      # Check prerequisites
      Invoke-AtomicTest $apt41[$c][0] -TestNumbers $apt41[$c][1] -CheckPrereqs

      # Run the test
      Invoke-AtomicTest $apt41[$c][0] -TestNumbers $apt41[$c][1]

      Write-Output "[!!!!!!!! END ATOMIC TEST TID-$tid at $date_time !!!!!!!]" | yellow
   } catch {
      Write-Output "`n >> An unexpected Error occured. Try again later ...`n"
   }
   $c++
}
