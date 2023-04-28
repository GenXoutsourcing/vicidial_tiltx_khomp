#!/bin/bash

##
# Name: GeoIP Firewall script
# Author: Pandry
# Version: 0.1.1
# Description: This is a simple script that will set up a GeoIP firewall blocking all the zones excecpt the specified ones
#                it is possible to add the whitelisted zones @ line 47
# Additional notes: Usage of [iprange](https://github.com/firehol/iprange) is suggested
#                     for best performances
##

BLACKLIST_NAME="geoblacklist"
TMPDIR="/tmp/geoip"

if [ $(which yum) ]; then
	echo -e "[\e[32mOK\e[39m] Detected a RHEL based environment!"
    echo -e "[\e[93mDOING\e[39m] Making sure firewalld is installed..."
    yum -y install firewalld > /dev/null 2> /dev/null
    if [[ $? -eq 0 ]];then
        echo -e "[\e[32mOK\e[39m] firewalld is installed!"
        systemctl enable --now firewalld  > /dev/null 2> /dev/null
    else
        echo -e "[\e[31mFAIL\e[39m] Couldn't install firewalld, aborting!"
        exit 1
    fi
elif [ $(which apt) ]; then
	echo -e "[\e[32mOK\e[39m] Detected a Debian based environment!"
    echo -e "[\e[93mDOING\e[39m] Making sure firewalld is installed..."
    apt -y install firewalld > /dev/null 2> /dev/null
    if [[ $? -eq 0 ]];then
        echo -e "[\e[32mOK\e[39m] firewalld is installed!"
        systemctl enable --now firewalld > /dev/null 2> /dev/null
    else
        echo -e "[\e[31mFAIL\e[39m] Couldn't install firewalld, aborting!"
        exit 1
    fi
elif [ $(which apk) ]; then
	echo -e "[\e[31mFAIL\e[39m] Alpine Linux is not supported yet!"
	exit 1
else
	echo -e "[\e[31mFAIL\e[39m] Couldn't determine the current OS, aborting!"
	exit 1
fi


#Create the blacklist (only if necessary)
#200k should be enough - $(find . -name "*.zone" | xargs wc -l) gives 184688 lines without the it zone
firewall-cmd --get-ipsets| grep "$BLACKLIST_NAME" > /dev/null 2> /dev/null 
if [[ $? -ne 0 ]];then
    echo -e "[\e[93mDOING\e[39m] Creating "
     firewall-cmd --permanent --new-ipset="$BLACKLIST_NAME" --type=hash:net --option=family=inet --option=hashsize=4096 --option=maxelem=200000 > /dev/null 2> /dev/null 
    if [[ $? -eq 0 ]];then
        echo -e "[\e[32mOK\e[39m] Blacklist $BLACKLIST_NAME successfully created!"
    else
        echo -e "[\e[31mFAIL\e[39m] Couldn't create the blacklist $BLACKLIST_NAME, aborting!"
        exit 1
    fi
fi

#create the folder
mkdir -p $TMPDIR

#Downloads the GeoIP database
if [[ $? -eq 0 ]];then
    echo -e "[\e[93mDOING\e[39m] Downloading latest ip database... "
    curl -L -o $TMPDIR/geoip.tar.gz http://www.ipdeny.com/ipblocks/data/countries/all-zones.tar.gz > /dev/null 2> /dev/null
    if [[ $? -eq 0 ]];then
        echo -e "[\e[32mOK\e[39m] Database successfully downloaded!"
    else
        echo -e "[\e[31mFAIL\e[39m] Couldn't download the database, aborting!"
        exit 1
    fi
else 
    echo -e "[\e[31mFAIL\e[39m] Couldn't create the $TMPDIR directory!"
    exit 1
fi

#Extract the zones in the database
tar -xzf $TMPDIR/geoip.tar.gz -C $TMPDIR

#Remove all the zones you want to allow
rm $TMPDIR/us.zone $TMPDIR/ph.zone

#Add the IPs to the blacklist
for f in $TMPDIR/*.zone; do
    echo -e "[\e[93mDOING\e[39m] Adding lines from $f ..."
    firewall-cmd --permanent --ipset="$BLACKLIST_NAME" --add-entries-from-file=$f > /dev/null
    if [[ $? -eq 0 ]];then
        echo -e "[\e[32mOK\e[39m] Added $f with no issues";
    else
        echo -e "[\e[31mFAIL\e[39m] Some errors verified while adding the $f zone";
    fi
    echo ""
done

# Drop the IPs
firewall-cmd --permanent --zone=drop --add-source="ipset:$BLACKLIST_NAME" > /dev/null

# Add the Whitelist
firewall-cmd --permanent --add-rich-rule="rule family='ipv4' source address='74.208.129.213' accept"
firewall-cmd --permanent --add-rich-rule="rule family='ipv4' source address='45.3.191.82' accept"
firewall-cmd --permanent --add-service=http
firewall-cmd --permanent --add-service=https
firewall-cmd --permanent --add-port=8089/tcp
firewall-cmd --permanent --add-port=8089/udp
firewall-cmd --permanent --remove-service=ssh
firewall-cmd --permanent --remove-service=cockpit
firewall-cmd --permanent --remove-service=dhcpv6-client
firewall-cmd --permanent --add-port=10000-20000/udp
firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="3.216.197.4" port protocol="udp" port="5060" accept'
firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="34.196.59.250" port protocol="udp" port="5060" accept'
firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="34.200.206.65" port protocol="udp" port="5060" accept'
firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="13.56.51.225" port protocol="udp" port="5060" accept'
firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="54.151.113.200" port protocol="udp" port="5060" accept'
firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="54.193.203.21" port protocol="udp" port="5060" accept'
firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="3.216.197.4" port protocol="tcp" port="5060" accept'
firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="34.196.59.250" port protocol="tcp" port="5060" accept'
firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="34.200.206.65" port protocol="tcp" port="5060" accept'
firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="13.56.51.225" port protocol="tcp" port="5060" accept'
firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="54.151.113.200" port protocol="tcp" port="5060" accept'
firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="54.193.203.21" port protocol="tcp" port="5060" accept'

#Reload the firewall
firewall-cmd --reload

cd ~
# Remove the traces
rm -rf /tmp/geoip
