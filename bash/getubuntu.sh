#!/bin/bash
echo -e "Ubuntu ISO Downloader for Desktop x64 architectures\n"
echo -e "This script requires an active internet connection and superuser permissions.\nPlease ensure that you have access to both before proceeding."
cat < /dev/null > /dev/tcp/8.8.8.8/53; ONLINE=$( echo $? )
if [ $ONLINE -eq 0 ]; then
    echo -e "The network connection is up. Proceeding...\n"
else
  echo -e "The network connection is down.\nPlease connect to the internet and try again."
  exit
fi
echo -e "\nIn order for this bash script to work you first need to install the wget package for your distro, if not present.\nThis will require superuser permissions.\nAn apt-update will be necessary too, beforehand."
echo -e "\nInstalling the prerequisites...\n"
sudo apt-get update
sudo apt-get install wget
echo -e "\nFetching download URLs for available Ubuntu versions and building menu. Please wait..."
wget -r --spider -l0 -A iso ftp://releases.ubuntu.com/releases/.pool/ 2>&1 | grep -Eo '(ftp)://[^/"].+\-desktop\-amd64\.iso' | sort -u > urls.txt
readarray urlarr < urls.txt
cat urls.txt | awk -F"-" '{ print $2 }' > vnrs.txt
readarray vnrarr < vnrs.txt
VERSION=""
while [[ $VERSION = "" ]]; do
    echo -e "\nPlease enter the number corresponding to the Ubuntu version you want to download.\n"
    select VERSION in "${vnrarr[@]}"; do
         if [[ $VERSION = "" ]]; then
              echo -e "\nInvalid choice! Please enter a number from 1 to " ${#vnrarr[@]}
         else
              echo -e "So far so good!\nTODO: Add code for the download...\n"
              ARRVNR=$(( REPLY - 1 ))
              echo -e "\nFile selected is " ${urlarr[$ARRVNR]}
         fi
         break
     done
done
rm urls.txt
rm vnrs.txt
rm -rf releases.ubuntu.com
exit 0
