New-Variable Schall -Value 342.2 -Description "Schallgeschwindigkeit " -Option ReadOnly
do {
if ($Dauer -match '^\d+$' ) { Die Eingabe ist Falsch }
$Dauer = Read-Host -Prompt "Bitte geben sie die zeit an die der Donner nach dem Blitz kam ." }
 until ($Dauer -match '^\d+$' ) 
[ double ] $D = $Dauer
$Entfernung = $D * $Schall
Write-Host "Die Entfernung des Blitzes beträgt $Entfernung Meter ." 
Remove-Variable Schall -Force