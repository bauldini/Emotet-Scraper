####################OLD 


#!/bin/bash
########################################################
#       Author: Bauldini                               #
#       Version: 1.0                                   #
#       Name: EmotetDaily.sh                           #
#       Description: Grab Emotet IOC from URLHaus      #
########################################################
#Variables
url="https://urlhaus.abuse.ch/downloads/csv"
bulk="bulk.txt"
malware="emotet"
day=$(date +%Y-%m-%d)

#Remove previos days files
if ls ~/scripts/*.txt 1> /dev/null 2>&1;
then
        rm *.txt
fi

#Get the new days CSV files
curl -o $bulk $url

#Parse file for only the day of and Emotet malware
cat bulk.txt | grep $day | grep $malware > emotet.txt

#Parse for only URL and remove the starting and trailing "
cat emotet.txt | cut -d"," -f3 | sed -e 's/^"//' -e 's/"$//' > urls.txt

#Change the HTTP to HXXP to avoid spam filters
cat urls.txt | sed -e 's/http/hxxp/' > sanitized.txt

#Get only the FQDN for the TLD
cat urls.txt | cut -d"/" -f3 > fqdn.txt

#Mail the IOC list to email address wanted
echo "" | mail -s "Emotet IOCs ($day)" -A sanitized.txt email address

#Ping each FQDN gather IP for insertion to GrayLog server for GeoIP plotting

for ip in $(cat fqdn.txt);
do ping -c 1 $ip | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | uniq >> IPAddr.txt;
done
