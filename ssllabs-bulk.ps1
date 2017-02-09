<#SSLLabs bulk test tool uses the api of www.ssllabs.com to test ssl functionality and security of public adresses/websites
Created By TElskamp
 
#>
function Get-TimeStamp {
                              
                               $timeStamp =  (Get-Date -Format dd-MM-yyyy) + "_" + (Get-Date -Format HH-mm)
                              
                               Return $timeStamp
                }
 
$TS = Get-TimeStamp
$base = "https://api.ssllabs.com/api/v2"
$scriptdir = $Psscriptroot
$reportdir = "$scriptdir"+"\reports"
$InputFile = "$scriptdir"+"\urllist.txt"
$report = "$reportdir"+"\TempReport"+"$TS"+".csv"
$fullreport = "$reportdir"+"\Reportfull"+"$TS"+".csv"
$UrlList = get-content -Path $InputFile
 
#create Reportdir if not exists
if(!(Test-Path -Path $reportdir )){
    New-Item -ItemType directory -Path $reportdir
} 
 
 
#Starting first initialization of ssllabs using their api, the timeout is needed to prevent to many requests error (429)
foreach ($url in $UrlList) {
$url = $url.Trim()
    Write-Output "Initiate check of $url at SSLlab"
    Invoke-RestMethod -Uri "$base/analyze?host=$url&startNew=on&ignoreMismatch=on"
 start-sleep 20
 
}
 
write-output "waiting for temp report to generate"
start-sleep 15
New-Item $report -type file -force
 
#Retrieve ip address and tempreport
foreach ($url in $UrlList) {
$url = $url.Trim()
    Write-Output "retrieve ip address and temp report for $url at SSLlab"
    Invoke-RestMethod  -Uri "$base/analyze?host=$url&fromCache=on&maxAge=1&all=on&ignoreMismatch=on" | Select-Object -ExpandProperty endpoints -Property host |export-csv -LiteralPath $report -Notypeinformation -append -force
start-sleep 10
 
}
 
write-output "Waiting for 1 minute to give sslab the time to fully analyze your sites" 
write-output "Report written to $report"
start-sleep 5
write-output "Opening the temp report to kill the time"
start-sleep 5
import-csv -LiteralPath $report | Out-GridView
Start-Sleep 55
$resultA = import-csv -LiteralPath $report
 
New-Item $fullreport -type file -force
 
#fetching extended data for Fullreport
foreach ($entry in $resultA) {
    $hosturl = $($entry.host)
    $hostip = $($entry.ipAddress)
       Write-Output "fetching results for $hosturl"
 
    $resultE =  Invoke-RestMethod  -Uri "$base/getEndpointData?host=$hosturl&s=$hostip" | Select-Object -Property ipAddress, serverName, statusMessage, grade -ExpandProperty details
    start-sleep 10
    $grade = $resultE |Select-Object -property grade
    Write-Output "$hosturl scored $grade"
    $resultE |export-csv -append -force -NoTypeInformation -LiteralPath $fullreport
    }
 
write-output "Full report written to $fullreport"
 
#############-Mail-###########################
#uncomment line below and change the email adresses and smtp server details to have the reports sent by mail. 
#Send-MailMessage -From sslReport@yourdomain.com -Subject Report -To you@yourdomain.com -Attachments $fullreport, $report -Body "report" -Port 25 -SmtpServer smtp.yourdomain.com -UseSsl
