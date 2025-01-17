﻿# PI.ps1

# Windows ART
# Credits to https://github.com/redcanaryco/atomic-red-team and @anantkaul
# Created by @sudoheader
# """"""""""""""""""""""""""""""""""""""""
# !!!!! WARNING: RUN ON WINDOWS ONLY !!!!!
# """"""""""""""""""""""""""""""""""""""""

Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope CurrentUser -Force
Remove-Item $env:TEMP\svchost-exe.dmp -ErrorAction Ignore

if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
   $arguments = "& '" +$myinvocation.mycommand.definition + "'"
   Start-Process powershell -Verb runAs -ArgumentList $arguments
   Break
}

cls

## Change Technique IDs and TestNumbers in the format 'T1003 -TestNumbers 1,2,3', ....
$sandworm_team = @(('T1133', 1),
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
    ('T1059.005', 1),
    ('T1059.005', 2),
    ('T1059.005', 3),
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
    ('T1098', 1),
    ('T1098', 2),
    ('T1098', 4),
    ('T1098', 5),
    ('T1098', 6),
    ('T1098', 7),
    ('T1098', 8),
    ('T1136.002', 1),
    ('T1136.002', 2),
    ('T1136.002', 3),
    ('T1505.003', 1),
    ('T1140', 1),
    ('T1140', 2),
    ('T1562.002', 1),
    ('T1562.002', 2),
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
    ('T1485', 3)
)
$c = 0

foreach ($tid in $sandworm_team) {
    powershell.exe Invoke-AtomicTest $sandworm_team[$c][0] -TestNumbers $sandworm_team[$c][1] -GetPrereqs -Force
    $c++
}
