# TILTX VICIDIAL INSTALLATION SCRIPTS (Default is EST Timezone)
# AlmaLinux Vicidial Install pre_requisites 

```

hostnamectl set-hostname xxxxxx.xxxxx.xxx
### Use YOUR SubDomain

vi /etc/hosts
##Change domain name for actual server ip (xxx.xxx.xxx.xxx   complete domain name    subdomain only)

timedatectl set-timezone America/New_York

yum check-update
yum update -y
yum -y install epel-release
yum update -y
yum install git -y
yum install -y kernel*

#Disable SELINUX
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config    

reboot

````
  Reboot Before running this script

# Install VICIDIAL scripts

```
git clone https://github.com/GenXoutsourcing/vicidial_tiltx_khomp.git
cd vicidial_tiltx_khomp
```

# Execute Firewalld GeoBlock (US only allowed)
```
chmod +x geoblock.sh
./geoblock.sh
```

# Execute AlmaLinux Vicidial Install
```
chmod +x vicidial-install-almalinux.sh
./vicidial-install-almalinux.sh
```


# Install WEBRTC for VICIDIAL Now (coming soon)
# DO THIS IF YOU HAVE PUBLIC DOMAIN WITH PUBLIC IP ONLY

```
chmod +x vicidial-enable-webrtc.sh
./vicidial-enable-webrtc.sh
```
