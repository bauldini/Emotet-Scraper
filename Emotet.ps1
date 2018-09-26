[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;

$url = "https://urlhaus.abuse.ch/downloads/csv"
$bulk= "bulk.txt" 
$malware = "emotet"
$date = Get-Date -UFormat "%Y-%m-%d"
$final = 'Final.txt'


#Invoke-WebRequest -Uri $url -OutFile $bulk

Get-Content bulk.txt | Select-String -Pattern $date | Select-String -Pattern $malware | Out-File emotet.txt
Get-Content emotet.txt | ForEach-Object {$_.split(",")[2]} | Out-File dirtyurls.txt
(Get-Content dirtyurls.txt) | ForEach-Object {
	$_ -replace '"', "" `
	   -replace 'emotet', "" `
	   -replace 'heodo', "" `
	   -replace 'malware_download', "" `
	   -replace 'doc', "" `
	   -replace 'online', "" `
	   -replace 'urlhaus', "" `
	   -replace '\n', "" `
	} | Set-Content $final
(Get-Content Final.txt) | ? {$_.trim() -ne "" } | Set-Content Emotet_IoC.txt
