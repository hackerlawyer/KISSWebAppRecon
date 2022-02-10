#KISSRecon - Web App Recon Automation @christopherkolezynski @lawyer_hacker github.com/hackerlawyer hackerlawyer.home.blog Cu_Chulainn@wearehackerone.com

# Dependencies include nmap, amass, eyewitness, nikto
# Run Script from home aka /root/ directory!!!!!
# Add "--proxy-ip 127.0.0.1 --proxy-port 8080" to Eyewitness command to proxy all domains and file directories through ZAP or Burp

#Uncomment Lines 8 through 27 to install dependencies

# git clone https://github.com/FortyNorthSecurity/EyeWitness
# cd EyeWitness
# ./setup.sh

# sudo apt install snapd
# sudo systemctl start snapd
# sudo systemctl enable snapd
# sudo snap install amass

# git clone https://github.com/EnableSecurity/wafw00f
# cd wafw00f
# python setup.py install

# sudo apt-get install nmap

# sudo apt-get install nikto -y

# apt-get install gobuster

# Wappalyzer

#add gau
#https://github.com/lc/gau
#e.g. echo "example.com" | gau -subs  This will pull all discoverable urls from domain and subdomains


#! /bin/bash

cat << "EOF"        
 ___  ____                       _____ _      ______   _                    __          ______   _                         _       __  
|_  ||_  _|                     |_   _/ |_  .' ____ \ (_)                  [  |       .' ____ \ / |_                      (_)     |  ] 
  | |_/ /  .---. .---. _ .--.     | |`| |-' | (___ \_|__  _ .--..--. _ .--. | |.---.  | (___ \_`| |-'.--.   .--.  _ .--.  __  .--.| |  
  |  __'. / /__\/ /__\[ '/'`\ \   | | | |    _.____`.[  |[ `.-. .-. [ '/'`\ | / /__\\  _.____`. | |/ .'`\ / .'`\ [ '/'`\ [  / /'`\' |  
 _| |  \ \| \__.| \__.,| \__/ |  _| |_| |,  | \____) || | | | | | | || \__/ | | \__., | \____) || || \__. | \__. || \__/ || | \__/  |  
|____||____'.__.''.__.'| ;.__/  |_____\__/   \______.[___[___||__||__| ;.__[___'.__.'  \______.'\__/'.__.' '.__.' | ;.__/[___'.__.;__] 
                      [__|_      ____    __           _             [__|   _______                               [__|                  
                      |_  _|    |_  _|  [  |         / \                  |_   __ \                                                    
                        \ \  /\  / .---. | |.--.    / _ \   _ .--.  _ .--.  | |__) | .---. .---.  .--.  _ .--.                         
                         \ \/  \/ / /__\\| '/'`\ \ / ___ \ [ '/'`\ [ '/'`\ \|  __ / / /__\/ /'`\/ .'`\ [ `.-. |                        
                          \  /\  /| \__.,|  \__/ _/ /   \ \_| \__/ || \__/ _| |  \ \| \__.| \__.| \__. || | | |                        
                           \/  \/  '.__.[__;.__.|____| |____| ;.__/ | ;.__|____| |___'.__.'.___.''.__.'[___||__]                       
                       ____  __                            [__|    [__|   __                  __                                       
                     .' __ \[  |                                         [  |                [  |  _                                   
                    / .'  \ || | ,--. _   _   __ _   __ .---. _ .--.      | |--.  ,--.  .---. | | / ].---. _ .--.                      
                    | | (_/ || |`'_\ [ \ [ \ [  [ \ [  / /__\[ `/'`\]     | .-. |`'_\ :/ /'`\]| '' </ /__\[ `/'`\]                     
                    \ `.__.'\| |// | |\ \/\ \/ / \ '/ /| \__.,| | _______ | | | |// | || \__. | |`\ | \__.,| |                         
                     `.___ .[___\'-;__/\__/\__/[\_:  /  '.__.[___|_______[___]|__\'-;__'.___.[__|  \_'.__.[___]                        
                                                \__.'                                                                                  
                                                                                                         
EOF


#Asks user for TARGET Domain

echo Please Enter Your TARGET Domain without WWW or HTTPS Prefix. Make sure you are running script from root directory and adjust this script to fit your wordlists and dns resolvers!

read TARGET

mkdir KISS_TARGET_RECON && cd KISS_TARGET_RECON

echo BEGINNING BASIC RECON!

cat << "EOF"
  _  __ _____  _____  ____  ___  _   _       ___  _____          ____  _____  ___    ___   ____  ___  ____   _  _  _  _ 
 | |/ /| ____|| ____||  _ \|_ _|| \ | |     |_ _||_   _|        / ___||_   _|/ _ \  / _ \ |  _ \|_ _||  _ \ | || || || |
 | ' / |  _|  |  _|  | |_) || | |  \| |      | |   | |          \___ \  | | | | | || | | || |_) || | | | | || || || || |
 | . \ | |___ | |___ |  __/ | | | |\  |      | |   | |           ___) | | | | |_| || |_| ||  __/ | | | |_| ||_||_||_||_|
 |_|\_\|_____||_____||_|   |___||_| \_|     |___|  |_|          |____/  |_|  \___/  \___/ |_|   |___||____/ (_)(_)(_)(_)
                                                                                                                        
EOF

echo Performing Subdomain Enumeration
echo Remember to modify DNS Resolver List Directory Path to Fit Your Needs!
echo Enumerating Target Subdomains with Amass!
amass enum -rf /root/KISSWebAppRecon/DNSResolvers -max-dns-queries 25000 -active -brute -d $TARGET | tee TARGETamassoutput.txt
echo EXPERIMENTAL - URLS TO IP ADDRESS USING HOST LOOKUP WITH DUPLICATE OUTPUTS REMOVED, CLEANS OUTPUT, AND APPENDS OUTPUT TO TARGETamassoutput.txt
cat TARGETamassoutput.txt | while read line; do host $line| grep "has address" |cut -d" " -f4| sort | uniq | >> TARGETamassoutput.txt; done

# EXPERIMENTAL - PERFORMS REVERSE LOOKUP ON IP ADDRESSES, CLEANS OUTPUT, AND APPENDS OUTPUT TO TARGETamassoutput.txt
# cat converteduniqueips.txt | while read line; do host $line| cut -d" " -f1 >> TARGETamassoutput.txt; done
# EXPERIMENTAL - PERFORMS DNS ZONE TRANSFERS, CLEANS OUTPUT, AND APPENDS OUTPUT TO TARGETamassoutput.txt
# cat TARGETamassoutput.txt | while read line; do host -t ns $line| grep "name server" |cut -d" " -f3 > domain_name_servers.txt
# cat domain_name_servers.txt | while read line; do host -l $TARGET $line  >> TARGETamassoutput.txt; done

cat << "EOF"
  ____  _____  ___  _      _         _  __ _____  _____  ____  ___  _   _      ___  _____      ____  _____  ___    ___   ____  ___  ____   _  _  _  _ 
 / ___||_   _||_ _|| |    | |       | |/ /| ____|| ____||  _ \|_ _|| \ | |    |_ _||_   _|    / ___||_   _|/ _ \  / _ \ |  _ \|_ _||  _ \ | || || || |
 \___ \  | |   | | | |    | |       | ' / |  _|  |  _|  | |_) || | |  \| |     | |   | |      \___ \  | | | | | || | | || |_) || | | | | || || || || |
  ___) | | |   | | | |___ | |___    | . \ | |___ | |___ |  __/ | | | |\  |     | |   | |       ___) | | | | |_| || |_| ||  __/ | | | |_| ||_||_||_||_|
 |____/  |_|  |___||_____||_____|   |_|\_\|_____||_____||_|   |___||_| \_|    |___|  |_|      |____/  |_|  \___/  \___/ |_|   |___||____/ (_)(_)(_)(_)
                                                                                                                                                                                                                                                                            
EOF

#echo Brute Forcing Subdomain Directories!
#echo Remember to modify Brute Force Wordlist Directory Path to Fit Your Needs!
#cat TARGETamassoutput.txt | while read line; do wafw00f $line > wafw00fsubdomainoutput.txt; done &
#Reads each line of Amass output and brute forces 10000 possible directory paths for each subdomain
#cat TARGETamassoutput.txt | while read line; do gobuster -w /root/KISSWebAppRecon/top10000.txt dir -u https://$line -e -n -q -t 50 -s 200, 301, 302, 403, 401 -k > GobusterTARGEToutput.txt &
#wait

#EXPERIMENTAL - WhatWeb Scanning of Subdomains. Turned off by default. User may experience issues with this command.
#echo Running WhatWeb on subdomains! 
#cat TARGETamassoutput.txt | while read line; do whatweb --user-agent='Mozilla/5.0 (Macintosh; Intel Mac OS X x.y; rv:10.0) Gecko/20100101 Firefox/10.0' --aggression=4 --follow-redirect=same-site --proxy 127.0.0.1:8080 -v https://$line | tee WhatWebSubdomainoutput; done
#dirb https://www.$TARGET /root/Downloads/Tools/Fuzzing/RobotsDisallowed/curated.txt -t | tee DirBTARGEToutput

#echo Cleaning up Gobuster Output!
# Removes all lines containing "Error:" or "unable to connect" from Gobuster output and saves as new file
#grep -vwE "(Error:|unable to connect)" GobusterTARGEToutput.txt > GobusterTARGEToutputEdited.txt

cat << "EOF"
  ____  _____  ___  _      _         _  __ _____  _____  ____  ___  _   _      ___  _____      ____  _____  ___    ___   ____  ___  ____   _  _  _  _ 
 / ___||_   _||_ _|| |    | |       | |/ /| ____|| ____||  _ \|_ _|| \ | |    |_ _||_   _|    / ___||_   _|/ _ \  / _ \ |  _ \|_ _||  _ \ | || || || |
 \___ \  | |   | | | |    | |       | ' / |  _|  |  _|  | |_) || | |  \| |     | |   | |      \___ \  | | | | | || | | || |_) || | | | | || || || || |
  ___) | | |   | | | |___ | |___    | . \ | |___ | |___ |  __/ | | | |\  |     | |   | |       ___) | | | | |_| || |_| ||  __/ | | | |_| ||_||_||_||_|
 |____/  |_|  |___||_____||_____|   |_|\_\|_____||_____||_|   |___||_| \_|    |___|  |_|      |____/  |_|  \___/  \___/ |_|   |___||____/ (_)(_)(_)(_)
                                                                                                                                                                                                                                                                            
EOF

echo Taking Screenshots of Domains!
echo Running Amass output through Eyewitness!
echo Modify File Input and Output Directories Where Appropiate! Add --proxy-ip 127.0.0.1 --proxy-port 8080 to pass requests through ZAP or Burp! Do not use on large output! During testing proxying worked but froze ZAP and session was too larget to reopen!
eyewitness --prepend-https --threads 20 --ocr --no-prompt -f /root/KISSWebAppRecon/TARGETamassoutput.txt -d /root/KISSWebAppRecon/KISS_TARGET_RECON/TARGETSubdomainsEyeWitnessReportFolder
#eyewitness --prepend-https --threads 20 --ocr --no-prompt -f /root/Downloads/Tools/KISSWebAppRecon/GobusterTARGEToutputEdited.txt -d /root/KISSWebAppRecon/KISS_TARGET_RECON/TARGETSubdomainDirectoriesEyeWitnessReportFolder &
#eyewitness --all-protocols --prepend-https --threads 3 --active-scan --ocr --no-prompt -f /root/KISSWebAppRecon/KISS_TARGET_RECON/#GobusterTARGEToutputEdited.txt #-d /root/KISSWebAppRecon/KISS_TARGET_RECON/EyeWitnessGobusterDirectoriesTARGEToutputReportFolder
wait

# Uncomment The Following 2-4 Lines to Clone subdomains using wget or httrack. This will add significant time to testing potentially 24 hours or more. This feature has been turned off by default.
#echo 5. Cloning Domains!
#echo Cloning Enumerated Target Subdomains with Wget and httrack!
#cat TARGETamassoutput.txt | while read line; do wget -r -l 0 -U "Mozilla Firefox /5.0" --wait=2 --no-check-certificate --mirror --convert-links --adjust-extension --page-requisites https://$line -P Website_Clones ;done
#httrack --list TARGETamassoutput.txt --spider -P 127.0.0.1:8080 -O /root/Downloads/Tools/KISSWebAppReconCRED/KISS_TARGET_RECON/HTTRack

#EXPERIMENTAL - Additional enumeration with dnsrecon. Unnecessary by default.
#echo DNSRecon enumeration, zonewalk, and whois lookup!
#dnsrecon -threads 20 -g -b -c -z -w -z -d $TARGET | tee DNSReconTARGEToutput

#EXPERIMENTAL - Surplus nMap testing with limited value
#echo Enumerating Misc. Info with nMap! 
#nmap -T4 --script=http-sitemap-generator,http-wordpress-enum,http-xssed,nbstat,netbus-info,vnc-info,whois-domain,http-passwd,http-enum -iL #TARGETamassoutput.txt | tee NmapMiscTargetOutput

echo BEGINNING VULNERABILITY AND PORT SCANNING!

cat << "EOF"
  ____  _____  ___  _      _         _  __ _____  _____  ____  ___  _   _      ___  _____      ____  _____  ___    ___   ____  ___  ____   _  _  _  _ 
 / ___||_   _||_ _|| |    | |       | |/ /| ____|| ____||  _ \|_ _|| \ | |    |_ _||_   _|    / ___||_   _|/ _ \  / _ \ |  _ \|_ _||  _ \ | || || || |
 \___ \  | |   | | | |    | |       | ' / |  _|  |  _|  | |_) || | |  \| |     | |   | |      \___ \  | | | | | || | | || |_) || | | | | || || || || |
  ___) | | |   | | | |___ | |___    | . \ | |___ | |___ |  __/ | | | |\  |     | |   | |       ___) | | | | |_| || |_| ||  __/ | | | |_| ||_||_||_||_|
 |____/  |_|  |___||_____||_____|   |_|\_\|_____||_____||_|   |___||_| \_|    |___|  |_|      |____/  |_|  \___/  \___/ |_|   |___||____/ (_)(_)(_)(_)
                                                                                                                                                                                                                                                                            
EOF

echo Scanning target subdomains 4 open ports and vulnerabilities!
nmap -Pn -sS -sV -O -sC -top-ports 1000 -T5 --script vuln -iL TARGETamassoutput.txt -oX TARGETAmassNmapScanResults.xml | tee NMAPVULNSCANoutput.txt &
cat TARGETamassoutput.txt | while read line; do nikto -Tuning x 1 6 -ssl -h $line -Format html -o NiktoSubdomainScans.html; done > NiktoSubdomainScansOutput.txt &
wait

cat << "EOF"
  ____  _____  ___  _      _         _  __ _____  _____  ____  ___  _   _      ___  _____      ____  _____  ___    ___   ____  ___  ____   _  _  _  _ 
 / ___||_   _||_ _|| |    | |       | |/ /| ____|| ____||  _ \|_ _|| \ | |    |_ _||_   _|    / ___||_   _|/ _ \  / _ \ |  _ \|_ _||  _ \ | || || || |
 \___ \  | |   | | | |    | |       | ' / |  _|  |  _|  | |_) || | |  \| |     | |   | |      \___ \  | | | | | || | | || |_) || | | | | || || || || |
  ___) | | |   | | | |___ | |___    | . \ | |___ | |___ |  __/ | | | |\  |     | |   | |       ___) | | | | |_| || |_| ||  __/ | | | |_| ||_||_||_||_|
 |____/  |_|  |___||_____||_____|   |_|\_\|_____||_____||_|   |___||_| \_|    |___|  |_|      |____/  |_|  \___/  \___/ |_|   |___||____/ (_)(_)(_)(_)
                                                                                                                                                                                                                                                                            
EOF

#EXPERIMENTAL -- Golismero Vuln Scan
#echo Scanning target Subdomains with Golisermo
#golismero scan $TARGET | tee TARGETGolismeroScanOutput
#golismero scan -i /root/KISS_TARGET_RECON/TARGETAmassNmapScanResults.xml -o TARGETAmassNmapScanResults.html
#cat TARGETamassoutput.txt | while read line; do golismero scan $line ;done | tee TARGETGolismeroScanOutput

echo Finished! Remember to rename output directory KISS_TARGET_RECON so it isnt overwritten the next time this tool runs!
done 
