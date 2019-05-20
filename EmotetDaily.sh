#!/bin/bash
########################################################
#       Author: Bauldini                               #
#       Version: 1.5                                   #
#       Name: EmotetDaily.sh                           #
#       Description: Grab Emotet IOC from URLHaus      #
########################################################

### V1.5 added whitelist feature
### V1.5 Added date to log files to track progress

#Variables
url="https://urlhaus.abuse.ch/downloads/csv"
c2="https://raw.githubusercontent.com/ring0x0/emotet-configs/master/master_list_unique.txt"
bulk="bulk.txt"
malware="emotet"
day=$(date +%Y-%m-%d)

#Remove previos days files
if ls /root/Emotet *.txt 1> /dev/null 2>&1;
then
        rm /root/Emotet/*.txt  /root/Emotet/*.json
fi

#Get the new days CSV files
curl --insecure -o /root/Emotet/$bulk $url

curl --insecure -o /root/Emotet/c2s.txt $c2

#Parse file for only the day of and Emotet malware
cat /root/Emotet/bulk.txt | grep $day | grep $malware > /root/Emotet/emotet.txt

#Parse for only URL and remove the starting and trailing "
cat /root/Emotet/emotet.txt | cut -d"," -f3 | sed -e 's/^"//' -e 's/"$//' > /root/Emotet/inital_urls.txt

grep -vf /root/White/WhiteURL.txt /root/Emotet/inital_urls.txt > /root/Emotet/urls.txt

cat /root/Emotet/c2s.txt | cut -d":" -f1 > /root/Emotet/initalc2.txt

grep -vf /root/White/WhiteC2.txt /root/Emotet/initalc2.txt > /root/Emotet/c2final.txt
echo "Bash Complete"

#Update the NamePulse for Emotet URLs and Domains

/usr/bin/python2 /root/Emotet/name_Emotet_C2.py
/usr/bin/python2 /root/Emotet/Name_Emotet_url.py
