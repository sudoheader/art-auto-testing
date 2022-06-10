# PI.ps1

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
$wizard_spider = @(('T1133', 1),
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
        ('T1053.005', 1),
        ('T1053.005', 2),
        ('T1053.005', 3),
        ('T1053.005', 4),
        ('T1053.005', 5),
        ('T1053.005', 6),
        ('T1053.005', 7),
        ('T1569.002', 1),
        ('T1569.002', 2),
        ('T1204.002', 1),
        ('T1204.002', 2),
        ('T1204.002', 3),
        ('T1204.002', 4),
        ('T1204.002', 5),
        ('T1204.002', 6),
        ('T1204.002', 7),
        ('T1204.002', 8),
        ('T1204.002', 9),
        ('T1204.002', 10),
        ('T1047', 1),
        ('T1047', 2),
        ('T1047', 3),
        ('T1047', 4),
        ('T1047', 5),
        ('T1047', 6),
        ('T1047', 7),
        ('T1047', 8),
        ('T1047', 9),
        ('T1047', 10),
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
        ('T1547.004', 1),
        ('T1547.004', 2),
        ('T1547.004', 3),
        ('T1543.003', 1),
        ('T1543.003', 2),
        ('T1543.003', 3),
        ('T1543.003', 4),
        ('T1055', 1),
        ('T1055', 2),
        ('T1055.001', 1),
        ('T1222.001', 1),
        ('T1222.001', 2),
        ('T1222.001', 3),
        ('T1222.001', 4),
        ('T1222.001', 5),
        #('T1562.001', 10), These two unload and uninstall Sysmon which prevents
        #('T1562.001', 11), winlogbeat to send logs for ELK stack, run them separately
        ('T1562.001', 12),
        ('T1562.001', 13),
        ('T1562.001', 14),
        ('T1562.001', 15),
        ('T1562.001', 16),
        ('T1562.001', 17),
        ('T1562.001', 18),
        ('T1562.001', 19),
        ('T1562.001', 20),
        ('T1562.001', 21),
        ('T1562.001', 22),
        ('T1562.001', 23),
        ('T1562.001', 24),
        ('T1562.001', 25),
        ('T1562.001', 26),
        ('T1562.001', 27),
        ('T1562.001', 28),
        ('T1562.001', 29),
        ('T1070', 1),
        ('T1070.004', 4),
        ('T1070.004', 5),
        ('T1070.004', 6),
        ('T1070.004', 7),
        ('T1070.004', 9),
        ('T1070.004', 10),
        ('T1036', 1),
        ('T1036', 2),
        ('T1036.004', 1),
        ('T1036.004', 2),
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
        ('T1027', 2),
        ('T1027', 3),
        ('T1027', 4),
        ('T1027', 5),
        ('T1027', 6),
        ('T1027', 7),
        ('T1557.001', 1),
        ('T1003', 1),
        ('T1003', 2),
        ('T1003', 3),
        ('T1003.002', 1),
        ('T1003.002', 2),
        ('T1003.002', 3),
        ('T1003.002', 4),
        ('T1003.002', 5),
        ('T1003.002', 6),
        ('T1003.003', 1),
        ('T1003.003', 2),
        ('T1003.003', 3),
        ('T1558.003', 1),
        ('T1558.003', 2),
        ('T1558.003', 3),
        ('T1558.003', 4),
        ('T1558.003', 5),
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
        ('T1016', 1),
        ('T1016', 2),
        ('T1016', 4),
        ('T1016', 5),
        ('T1016', 6),
        ('T1016', 7),
        ('T1033', 1),
        ('T1033', 3),
        ('T1033', 4),
        ('T1033', 5),
        ('T1021.001', 1),
        ('T1021.001', 2),
        ('T1021.001', 3),
        ('T1021.001', 4),
        ('T1021.002', 1),
        ('T1021.002', 2),
        ('T1021.002', 3),
        ('T1021.002', 4),
        ('T1021.006', 1),
        ('T1021.006', 2),
        ('T1021.006', 3),
        ('T1071.001', 1),
        ('T1071.001', 2),
        ('T1489', 1),
        ('T1489', 2),
        ('T1489', 3))

$present_dir = "$res_loc\ART_Results\$date_time"
$c = 0

foreach ($tid in $wizard_spider) {

   if (Test-Path $present_dir) {
      # Write-Output " >> Previous AtomicTest Overwriting and Updating with the Latest AtomicTest ..."
   } else {
      mkdir $present_dir > 1.md; rm 1.md
   }

   try {

      Write-Output "`n[******** BEGIN TID-$tid Brief Details *******]" | Tee-Object -file $present_dir\Brief_Details.txt -Append | yellow
      powershell.exe Invoke-AtomicTest $wizard_spider[$c][0] -TestNumbers $wizard_spider[$c][1] -ShowDetailsBrief | Add-Content $present_dir\Brief_Details_temp.txt
      cat $present_dir\Brief_Details_temp.txt
      cat $present_dir\Brief_Details_temp.txt >> $present_dir\Brief_Details.txt
      rm $present_dir\Brief_Details_temp.txt
      Write-Output "[!!!!!!!! END TID-$tid Brief Details !!!!!!!]" | Tee-Object -file $present_dir\Brief_Details.txt -Append | yellow

      Write-Output "`n[******** BEGIN TID-$tid Full Details *******]" | Tee-Object -file $present_dir\Full_Details.md -Append | yellow
      powershell.exe Invoke-AtomicTest $wizard_spider[$c][0] -TestNumbers $wizard_spider[$c][1] -ShowDetails | Add-Content $present_dir\Full_Details_temp.md
      cat $present_dir\Full_Details_temp.md
      cat $present_dir\Full_Details_temp.md >> $present_dir\Full_Details.md
      rm $present_dir\Full_Details_temp.md
      Write-Output "[!!!!!!!! END TID-$tid Full Details !!!!!!!]" | Tee-Object -file $present_dir\Full_Details.md -Append | yellow

      # Try installing the dependencies first ...
      powershell.exe Invoke-AtomicTest $wizard_spider[$c][0] -TestNumbers $wizard_spider[$c][1] -GetPrereqs -Force # | Add-Content $present_dir\get_preq.md
      Write-Output "`n[******** BEGIN ATOMIC TEST TID-$tid *******]" | Tee-Object -file $present_dir\Output.md -Append | yellow            
      powershell.exe Invoke-AtomicTest $wizard_spider[$c][0] -TestNumbers $wizard_spider[$c][1] -CheckPrereqs
      powershell.exe Invoke-AtomicTest $wizard_spider[$c][0] -TestNumbers $wizard_spider[$c][1] -ExecutionLogPath `"$present_dir\Logs.csv`" | Add-Content $present_dir\Output_temp.md
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
