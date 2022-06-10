﻿# AtomicRedTeam APT41 Cleanup ...

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

$date_time = Get-Date -Format "MM:dd:yyyy_HH:mm"
$date_time = $date_time.Replace(':', "-")
cls

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

$cleanup_dir = "$res_loc\ART_Results\Cleanups"

if (Test-Path $cleanup_dir) {
} else {
  mkdir $cleanup_dir > 1.md; rm 1.md
}
# $cl = "$cleanup_dir\cleanup_APT41.txt"

$c = 0
foreach ($tid in $apt41) {
    Write-Output "`n[******** BEGIN TEST-$tid CLEANUP *******]" | Tee-Object -file $cleanup_dir\$date_time.txt -Append | yellow
    powershell.exe Invoke-AtomicTest $apt41[$c][0] -TestNumbers $apt41[$c][1] -Cleanup | Add-Content $cleanup_dir\temp.txt
    cat $cleanup_dir\temp.txt
    cat $cleanup_dir\temp.txt >> $cleanup_dir\$date_time.txt
    rm $cleanup_dir\temp.txt
    Write-Output "[!!!!!!!! END  TEST-$tid CLEANUP !!!!!!!]" | Tee-Object -file $cleanup_dir\$date_time.txt -Append | yellow
}

Write-Output "`n >> Cleanup Logs stored in `"$cleanup_dir\$date_time.txt`" ...`n" | green