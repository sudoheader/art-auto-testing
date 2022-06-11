﻿# PI.ps1

# Windows ART
# Credits to https://github.com/redcanaryco/atomic-red-team and @anantkaul
# Created by @sudoheader
# """"""""""""""""""""""""""""""""""""""""
# !!!!! WARNING: RUN ON WINDOWS ONLY !!!!!
# """"""""""""""""""""""""""""""""""""""""

$res_loc = "C:\AtomicRedTeam\VTF"

Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope CurrentUser -Force
Remove-Item $env:TEMP\svchost-exe.dmp -ErrorAction Ignore

if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
   $arguments = "& '" +$myinvocation.mycommand.definition + "'"
   Start-Process powershell -Verb runAs -ArgumentList $arguments
   Break
}

function green {
   process { Write-Host $_ -ForegroundColor Green }
}
function yellow {
   process { Write-Host $_ -ForegroundColor Yellow }
}

# Checking Invoke-Atomic Framework
if (-not (Test-Path -Path C:\AtomicRedTeam\invoke-atomicredteam)) {
   Write-Output "`n >> Installing Invoke-Atomic Framework ...`n"
   Install-Module -Name invoke-atomicredteam,powershell-yaml -Scope CurrentUser -Force
   Write-Output "`n >> Installed Invoke-Atomic Framework successfully ..." | green
}
# Checking the atomics
if (-not (Test-Path -Path C:\AtomicRedTeam\atomics)) {
   Write-Output "`n >> Getting the atomics ...`n"
   Invoke-Expression (Invoke-WebRequest 'https://raw.githubusercontent.com/redcanaryco/invoke-atomicredteam/master/install-atomicredteam.ps1' -UseBasicParsing); Install-AtomicRedTeam -getAtomics -Force
   # Importing the module
   Import-Module "C:\AtomicRedTeam\invoke-atomicredteam\Invoke-AtomicRedTeam.psd1" -Force
   Write-Output " >> Successfully Installed `"Atomic-Red-Team`" in `"C:\AtomicRedTeam\`" ..." | green
   Read-Host -Prompt "`n >> Press enter to continue"
}

$date_time = Get-Date -Format "MM:dd:yyyy_HH:mm"
$date_time = $date_time.Replace(':', "-")
cls

## Change Technique IDs and TestNumbers in the format 'T1003 -TestNumbers 1,2,3', ....
$sandworm_team = @(
    # ('T1562.002', 2), # You'll need to restart PC after performing this TID
    ('T1562.002', 3),
    ('T1562.002', 4),
    ('T1562.002', 5),
    ('T1562.002', 6),
    ('T1070', 1),
    ('T1070.004', 4),
    ('T1070.004', 5),
    ('T1070.004', 6),
    ('T1070.004', 7),
    ('T1070.004', 9),
    ('T1070.004', 10),
    ('T1036', 1),
    ('T1036', 2),
    ('T1036.005', 2),
    ('T1027', 2),
    ('T1027', 3),
    ('T1027', 4),
    ('T1027', 5),
    ('T1027', 6),
    ('T1027', 7),
    ('T1218', 1),
    ('T1218', 2),
    ('T1218', 3),
    ('T1218', 4),
    ('T1218', 5),
    ('T1218', 6),
    ('T1218', 7),
    ('T1218', 8),
    ('T1218', 9),
    ('T1218', 10),
    ('T1218', 11),
    ('T1218', 12),
    ('T1218.011', 1),
    ('T1218.011', 2),
    ('T1218.011', 3),
    ('T1218.011', 4),
    ('T1218.011', 5),
    ('T1218.011', 6),
    ('T1218.011', 7),
    ('T1218.011', 8),
    ('T1218.011', 9),
    ('T1218.011', 10),
    ('T1218.011', 11),
    ('T1218.011', 12),
    ('T1110.003', 1),
    ('T1110.003', 2),
    ('T1110.003', 3),
    ('T1110.003', 4),
    ('T1555', 1),
    ('T1555', 2),
    ('T1555', 3),
    ('T1555', 4),
    ('T1555', 5),
    ('T1555.003', 1),
    ('T1555.003', 3),
    ('T1555.003', 4),
    ('T1555.003', 5),
    ('T1555.003', 6),
    ('T1555.003', 7),
    ('T1555.003', 8),
    ('T1555.003', 10),
    ('T1555.003', 11),
    ('T1056.001', 1),
    ('T1040', 3),
    ('T1040', 4),
    ('T1040', 5),
    ('T1040', 6),
    ('T1003', 1),
    ('T1003', 2),
    ('T1003', 3),
    ('T1003.001', 1),
    ('T1003.001', 2),
    ('T1003.001', 3),
    ('T1003.001', 4),
    ('T1003.001', 6),
    ('T1003.001', 7),
    ('T1003.001', 8),
    ('T1003.001', 9),
    ('T1003.001', 10),
    ('T1003.001', 11),
    ('T1003.001', 12),
    ('T1087.002', 1),
    ('T1087.002', 2),
    ('T1087.002', 3),
    ('T1087.002', 4),
    ('T1087.002', 5),
    ('T1087.002', 6),
    ('T1087.002', 7),
    ('T1087.002', 8),
    ('T1087.002', 9),
    ('T1087.002', 10),
    ('T1087.002', 11),
    ('T1087.002', 12),
    ('T1087.002', 13),
    ('T1087.002', 14),
    ('T1087.002', 15),
    ('T1083', 1),
    ('T1083', 2),
    ('T1083', 5),
    ('T1018', 1),
    ('T1018', 2),
    ('T1018', 3),
    ('T1018', 4),
    ('T1018', 5),
    ('T1018', 8),
    ('T1018', 9),
    ('T1018', 10),
    ('T1018', 11),
    ('T1018', 15),
    ('T1018', 16),
    ('T1018', 17),
    ('T1018', 18),
    ('T1018', 19),
    ('T1082', 1),
    ('T1082', 6),
    ('T1082', 8),
    ('T1082', 9),
    ('T1082', 10),
    ('T1082', 13),
    ('T1082', 14),
    ('T1082', 15),
    ('T1082', 16),
    ('T1082', 17),
    ('T1082', 18),
    ('T1082', 19),
    ('T1016', 1),
    ('T1016', 2),
    ('T1016', 4),
    ('T1016', 5),
    ('T1016', 6),
    ('T1016', 7),
    ('T1049', 1),
    ('T1049', 2),
    ('T1049', 4),
    ('T1033', 1),
    ('T1033', 3),
    ('T1033', 4),
    ('T1033', 5),
    ('T1021.002', 1),
    ('T1021.002', 2),
    ('T1021.002', 3),
    ('T1021.002', 4),
    ('T1041', 1),
    ('T1071.001', 1),
    ('T1071.001', 2),
    ('T1132.001', 2),
    ('T1105', 7),
    ('T1105', 8),
    ('T1105', 9),
    ('T1105', 10),
    ('T1105', 11),
    ('T1105', 12),
    ('T1105', 13),
    ('T1105', 15),
    ('T1105', 16),
    ('T1105', 17),
    ('T1105', 18),
    ('T1105', 19),
    ('T1105', 20),
    ('T1105', 21),
    ('T1105', 22),
    ('T1571', 1),
    ('T1219', 1),
    ('T1219', 2),
    ('T1219', 3),
    ('T1219', 4),
    ('T1219', 5),
    ('T1219', 6),
    ('T1219', 7),
    ('T1485', 1),
    ('T1485', 3))

$present_dir = "$res_loc\ART_Results\$date_time"
$c = 0

foreach ($tid in $sandworm_team) {

   if (Test-Path $present_dir) {
      # Write-Output " >> Previous AtomicTest Overwriting and Updating with the Latest AtomicTest ..."
   } else {
      mkdir $present_dir > 1.md; rm 1.md
   }

   try {

      Write-Output "`n[******** BEGIN TID-$tid Brief Details *******]" | Tee-Object -file $present_dir\Brief_Details.txt -Append | yellow
      powershell.exe Invoke-AtomicTest $sandworm_team[$c][0] -TestNumbers $sandworm_team[$c][1] -ShowDetailsBrief | Add-Content $present_dir\Brief_Details_temp.txt
      cat $present_dir\Brief_Details_temp.txt
      cat $present_dir\Brief_Details_temp.txt >> $present_dir\Brief_Details.txt
      rm $present_dir\Brief_Details_temp.txt
      Write-Output "[!!!!!!!! END TID-$tid Brief Details !!!!!!!]" | Tee-Object -file $present_dir\Brief_Details.txt -Append | yellow

      Write-Output "`n[******** BEGIN TID-$tid Full Details *******]" | Tee-Object -file $present_dir\Full_Details.md -Append | yellow
      powershell.exe Invoke-AtomicTest $sandworm_team[$c][0] -TestNumbers $sandworm_team[$c][1] -ShowDetails | Add-Content $present_dir\Full_Details_temp.md
      cat $present_dir\Full_Details_temp.md
      cat $present_dir\Full_Details_temp.md >> $present_dir\Full_Details.md
      rm $present_dir\Full_Details_temp.md
      Write-Output "[!!!!!!!! END TID-$tid Full Details !!!!!!!]" | Tee-Object -file $present_dir\Full_Details.md -Append | yellow

      # Try installing the dependencies first ...
      powershell.exe Invoke-AtomicTest $sandworm_team[$c][0] -TestNumbers $sandworm_team[$c][1] -GetPrereqs -Force # | Add-Content $present_dir\get_preq.md
      Write-Output "`n[******** BEGIN ATOMIC TEST TID-$tid *******]" | Tee-Object -file $present_dir\Output.md -Append | yellow
      powershell.exe Invoke-AtomicTest $sandworm_team[$c][0] -TestNumbers $sandworm_team[$c][1] -CheckPrereqs
      powershell.exe Invoke-AtomicTest $sandworm_team[$c][0] -TestNumbers $sandworm_team[$c][1] -ExecutionLogPath `"$present_dir\Logs.csv`" | Add-Content $present_dir\Output_temp.md
      # rm $present_dir\get_preq.md

      if (Test-Path $HOME\Desktop\open-ports.txt) {
        mv $HOME\Desktop\open-ports.txt $present_dir\Open_Ports.txt
      }

      cat $present_dir\Output_temp.md
      cat $present_dir\Output_temp.md >> $present_dir\Output.md
      rm $present_dir\Output_temp.md
      Write-Output "[!!!!!!!! END ATOMIC TEST TID-$tid !!!!!!!]" | Tee-Object -file $present_dir\Output.md -Append | yellow

      Write-Output "`n >> AtomicTest $tid Completed Successfully !!" | green
      Write-Output " >> Results Stored in `"$present_dir`" ...`n" | green
   } catch {
   Write-Output "`n >> An unexpected Error occured. Try again later ...`n"
   }

   $c++
}
