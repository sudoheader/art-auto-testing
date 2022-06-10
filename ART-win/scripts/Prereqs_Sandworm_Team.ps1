# PI.ps1

# Windows ART
# Credits to https://github.com/redcanaryco/atomic-red-team

Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope CurrentUser -Force
Remove-Item $env:TEMP\svchost-exe.dmp -ErrorAction Ignore

if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
   $arguments = "& '" +$myinvocation.mycommand.definition + "'"
   Start-Process powershell -Verb runAs -ArgumentList $arguments
   Break
} 

cls

## Change Technique IDs and TestNumbers in the format 'T1003 -TestNumbers 1,2,3', .... 
$fin6 = @(('T1003.003', 1),
          ('T1003.003', 2),
          ('T1003.003', 3),
          ('T1003.003', 4),
          ('T1003.003', 6),
          ('T1003.003', 7),
          ('T1003.003', 8),
          ('T1003.003', 9),
          ('T1003.003', 10),
          ('T1003.003', 11),
          ('T1003.003', 12),
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
          ('T1016', 7))
$c = 0

foreach ($tid in $fin6) {
    powershell.exe Invoke-AtomicTest $fin6[$c][0] -TestNumbers $fin6[$c][1] -GetPrereqs -Force
    $c++
}