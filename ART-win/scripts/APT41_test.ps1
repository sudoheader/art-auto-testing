# APT41_test.ps1

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
$apt41 = @(('T1133', 1),
    ('T1566.001', 1),
    ('T1566.001', 2),
    ('T1059.001', 1),
    ('T1059.001', 2),
    ('T1059.001', 3),
    ('T1059.001', 4),
    ('T1059.001', 5),
    ('T1059.001', 6),
    ('T1059.001', 7),
    ('T1059.001', 8),
    ('T1059.001', 9),
    ('T1059.001', 11),
    ('T1059.001', 12),
    ('T1059.001', 13),
    ('T1059.001', 14),
    ('T1059.001', 15),
    ('T1059.001', 16),
    ('T1059.001', 17),
    ('T1059.001', 18),
    ('T1059.001', 19),
    ('T1059.001', 20),
    ('T1059.001', 21),
    ('T1059.003', 1),
    ('T1059.003', 2),
    ('T1059.003', 3),
    ('T1059.003', 4),
    ('T1569.002', 1),
    ('T1569.002', 2),
    ('T1197', 1),
    ('T1197', 2),
    ('T1197', 3),
    ('T1197', 4),
    ('T1547', 1),
    ('T1547.001', 1),
    ('T1547.001', 2),
    ('T1547.001', 3),
    ('T1547.001', 4),
    ('T1547.001', 5),
    ('T1547.001', 6),
    ('T1547.001', 7),
    ('T1547.001', 8),
    ('T1547.001', 9),
    ('T1136.001', 3),
    ('T1136.001', 4),
    ('T1136.001', 6),
    ('T1543.003', 1),
    ('T1543.003', 2),
    ('T1543.003', 3),
    ('T1543.003', 4),
    ('T1546.008', 1),
    ('T1546.008', 2),
    ('T1574.001', 1),
    ('T1574.002', 1),
    ('T1070', 1),
    ('T1070.001', 1),
    ('T1070.001', 2),
    ('T1070.001', 3),
    ('T1070.003', 10),
    ('T1070.003', 11),
    ('T1070.004', 4),
    ('T1070.004', 5),
    ('T1070.004', 6),
    ('T1070.004', 7),
    ('T1070.004', 9),
    ('T1070.004', 10),
    ('T1112', 1),
    ('T1112', 2),
    ('T1112', 3),
    ('T1112', 4),
    ('T1112', 5),
    ('T1112', 6),
    ('T1112', 7),
    ('T1112', 8),
    ('T1112', 9),
    ('T1112', 10),
    ('T1112', 11),
    ('T1112', 12),
    ('T1112', 13),
    ('T1112', 14),
    ('T1112', 15),
    ('T1112', 16),
    ('T1112', 17),
    ('T1112', 18),
    ('T1112', 19),
    ('T1112', 20),
    ('T1112', 21),
    ('T1112', 22),
    ('T1112', 23),
    ('T1112', 24),
    ('T1112', 25),
    ('T1112', 26),
    ('T1112', 27),
    ('T1112', 28),
    ('T1112', 29),
    ('T1112', 30),
    ('T1112', 31),
    ('T1112', 32),
    ('T1112', 33),
    ('T1112', 34),
    ('T1218', 4),
    ('T1218', 5),
    ('T1218', 6),
    ('T1218', 7),
    ('T1218', 8),
    ('T1218', 9),
    ('T1218', 10),
    ('T1218', 11),
    ('T1218', 12),
    ('T1218.001', 1),
    ('T1218.001', 2),
    ('T1218.001', 3),
    ('T1218.001', 4),
    ('T1218.001', 5),
    ('T1218.001', 6),
    ('T1218.001', 7),
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
    ('T1110.002', 1),
    ('T1083', 1),
    ('T1083', 2),
    ('T1083', 5),
    ('T1135', 3),
    ('T1135', 4),
    ('T1135', 5),
    ('T1135', 6),
    ('T1135', 7),
    ('T1135', 8),
    ('T1560', 1),
    ('T1560.001', 1),
    ('T1560.001', 2),
    ('T1560.001', 3),
    ('T1560.001', 4),
    ('T1071.001', 1),
    ('T1071.001', 2),
    ('T1071.004', 1),
    ('T1071.004', 2),
    ('T1071.004', 3),
    ('T1071.004', 4),
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
    ('T1486', 5))

$present_dir = "$res_loc\ART_Results\$date_time"
$c = 0

foreach ($tid in $apt41) {

   if (Test-Path $present_dir) {
      # Write-Output " >> Previous AtomicTest Overwriting and Updating with the Latest AtomicTest ..."
   } else {
      mkdir $present_dir > 1.md; rm 1.md
   }

   try {

      Write-Output "`n[******** BEGIN TID-$tid Brief Details *******]" | Tee-Object -file $present_dir\Brief_Details.txt -Append | yellow
      powershell.exe Invoke-AtomicTest $apt41[$c][0] -TestNumbers $apt41[$c][1] -ShowDetailsBrief | Add-Content $present_dir\Brief_Details_temp.txt
      cat $present_dir\Brief_Details_temp.txt
      cat $present_dir\Brief_Details_temp.txt >> $present_dir\Brief_Details.txt
      rm $present_dir\Brief_Details_temp.txt
      Write-Output "[!!!!!!!! END TID-$tid Brief Details !!!!!!!]" | Tee-Object -file $present_dir\Brief_Details.txt -Append | yellow

      Write-Output "`n[******** BEGIN TID-$tid Full Details *******]" | Tee-Object -file $present_dir\Full_Details.md -Append | yellow
      powershell.exe Invoke-AtomicTest $apt41[$c][0] -TestNumbers $apt41[$c][1] -ShowDetails | Add-Content $present_dir\Full_Details_temp.md
      cat $present_dir\Full_Details_temp.md
      cat $present_dir\Full_Details_temp.md >> $present_dir\Full_Details.md
      rm $present_dir\Full_Details_temp.md
      Write-Output "[!!!!!!!! END TID-$tid Full Details !!!!!!!]" | Tee-Object -file $present_dir\Full_Details.md -Append | yellow

      # Try installing the dependencies first ...
      powershell.exe Invoke-AtomicTest $apt41[$c][0] -TestNumbers $apt41[$c][1] -GetPrereqs -Force # | Add-Content $present_dir\get_preq.md
      Write-Output "`n[******** BEGIN ATOMIC TEST TID-$tid *******]" | Tee-Object -file $present_dir\Output.md -Append | yellow
      powershell.exe Invoke-AtomicTest $apt41[$c][0] -TestNumbers $apt41[$c][1] -CheckPrereqs
      powershell.exe Invoke-AtomicTest $apt41[$c][0] -TestNumbers $apt41[$c][1] -ExecutionLogPath `"$present_dir\Logs.csv`" | Add-Content $present_dir\Output_temp.md
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
