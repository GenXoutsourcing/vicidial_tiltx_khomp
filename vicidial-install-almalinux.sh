#!/bin/sh

echo "Vicidial installation AlmaLinux with Tiltx/Khomp/Webphone(WebRTC/SIP.js)"

export LC_ALL=C


yum groupinstall "Development Tools" -y

yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
yum -y install http://rpms.remirepo.net/enterprise/remi-release-8.rpm
yum -y install yum-utils
dnf module enable php:remi-7.4 -y

dnf -y install dnf-plugins-core
dnf config-manager --set-enabled powertools

yum install -y php php-mcrypt php-cli php-gd php-curl php-mysql php-ldap php-zip php-fileinfo php-opcache wget unzip make patch gcc gcc-c++ subversion php php-devel php-gd gd-devel readline-devel php-mbstring php-mcrypt php-imap php-ldap php-mysql php-odbc php-pear php-xml php-xmlrpc curl curl-devel perl-libwww-perl ImageMagick libxml2 libxml2-devel httpd libpcap libpcap-devel libnet ncurses ncurses-devel screen kernel* mutt glibc.i686 certbot python3-certbot-apache mod_ssl openssl-devel newt-devel libxml2-devel kernel-devel sqlite-devel libuuid-devel sox sendmail lame-devel htop iftop perl-File-Which php-opcache libss7 mariadb-devel libss7* libopen* 
yum -y install sqlite-devel


tee -a /etc/httpd/conf/httpd.conf <<EOF

CustomLog /dev/null common

Alias /RECORDINGS/MP3 "/var/spool/asterisk/monitorDONE/MP3/"

<Directory "/var/spool/asterisk/monitorDONE/MP3/">
    Options Indexes MultiViews
    AllowOverride None
    Require all granted
</Directory>

###Uncomment and add SERVER_IP to block access by IP
#<VirtualHost *:80>
#ServerName INSERT SERVER_IP
#Redirect 403 /
#ErrorDocument 403 "Sorry, Direct IP access not allowed"
#DocumentRoot /var/www/html
#UserDir disabled
#</VirtualHost>

### Update ServerName with FQDN
#<VirtualHost *:80>
#    ServerName other.example.com
#</VirtualHost>


EOF


tee -a /etc/php.ini <<EOF

error_reporting  =  E_ALL & ~E_NOTICE
memory_limit = 448M
short_open_tag = On
max_execution_time = 3330
max_input_time = 3360
post_max_size = 448M
upload_max_filesize = 442M
default_socket_timeout = 3360
date.timezone = America/New_York
EOF


systemctl restart httpd


dnf install -y mariadb-server mariadb

dnf -y install dnf-plugins-core
dnf config-manager --set-enabled powertools


systemctl enable mariadb

cp /etc/my.cnf /etc/my.cnf.original
echo "" > /etc/my.cnf


cat <<MYSQLCONF>> /etc/my.cnf
[mysql.server]
user = mysql
#basedir = /var/lib

[client]
port = 3306
socket = /var/lib/mysql/mysql.sock

[mysqld]
datadir = /var/lib/mysql
#tmpdir = /home/mysql_tmp
socket = /var/lib/mysql/mysql.sock
user = mysql
old_passwords = 0
ft_min_word_len = 3
max_connections = 2000
max_allowed_packet = 32M
skip-external-locking
sql_mode="NO_ENGINE_SUBSTITUTION"

log-error = /var/log/mysqld/mysqld.log

query-cache-type = 1
query-cache-size = 32M

long_query_time = 1
#slow_query_log = 1
#slow_query_log_file = /var/log/mysqld/slow-queries.log

tmp_table_size = 128M
table_cache = 1024

join_buffer_size = 1M
key_buffer = 512M
sort_buffer_size = 6M
read_buffer_size = 4M
read_rnd_buffer_size = 16M
myisam_sort_buffer_size = 64M

max_tmp_tables = 64

thread_cache_size = 8
thread_concurrency = 8

# If using replication, uncomment log-bin below
#log-bin = mysql-bin

[mysqldump]
quick
max_allowed_packet = 16M

[mysql]
no-auto-rehash

[isamchk]
key_buffer = 256M
sort_buffer_size = 256M
read_buffer = 2M
write_buffer = 2M

[myisamchk]
key_buffer = 256M
sort_buffer_size = 256M
read_buffer = 2M
write_buffer = 2M

[mysqlhotcopy]
interactive-timeout

[mysqld_safe]
#log-error = /var/log/mysqld/mysqld.log
#pid-file = /var/run/mysqld/mysqld.pid
MYSQLCONF

mkdir /var/log/mysqld
touch /var/log/mysqld/slow-queries.log
chown -R mysql:mysql /var/log/mysqld
systemctl restart mariadb

systemctl enable httpd.service
systemctl enable mariadb.service
systemctl restart httpd.service
systemctl restart mariadb.service

#Install Perl Modules

echo "Install Perl"

yum install -y perl-CPAN perl-YAML perl-libwww-perl perl-DBI perl-DBD-MySQL perl-GD perl-Env perl-Term-ReadLine-Gnu perl-SelfLoader perl-open.noarch
cpan -i Tk String::CRC Tk::TableMatrix Net::Address::IP::Local Term::ReadLine::Gnu Spreadsheet::Read Net::Address::IPv4::Local RPM::Specfile Spreadsheet::XLSX Spreadsheet::ReadSXC MD5 Digest::MD5 Digest::SHA1 Bundle::CPAN Pod::Usage Getopt::Long DBI DBD::mysql Net::Telnet Time::HiRes Net::Server Mail::Sendmail Unicode::Map Jcode Spreadsheet::WriteExcel OLE::Storage_Lite Proc::ProcessTable IO::Scalar Scalar::Util Spreadsheet::ParseExcel Archive::Zip Compress::Raw::Zlib Spreadsheet::XLSX Test::Tester Spreadsheet::ReadSXC Text::CSV Test::NoWarnings Text::CSV_PP File::Temp Text::CSV_XS Spreadsheet::Read LWP::UserAgent HTML::Entities HTML::Strip HTML::FormatText HTML::TreeBuilder Switch Time::Local Mail::POP3Client Mail::IMAPClient Mail::Message IO::Socket::SSL readline

echo "Please Press ENTER for CPAN Install"

yum install perl-CPAN -y
yum install perl-YAML -y
yum install perl-libwww-perl -y
yum install perl-DBI -y
yum install perl-DBD-MySQL -y
yum install perl-GD -y
cd /usr/bin/
curl -LOk http://xrl.us/cpanm
chmod +x cpanm
cpanm -f File::HomeDir
cpanm -f File::Which
cpanm CPAN::Meta::Requirements
cpanm -f CPAN
cpanm YAML
cpanm MD5
cpanm Digest::MD5
cpanm Digest::SHA1
cpanm readline --force


cpanm Bundle::CPAN
cpanm DBI
cpanm -f DBD::mysql
cpanm Net::Telnet
cpanm Time::HiRes
cpanm Net::Server
cpanm Switch
cpanm Mail::Sendmail
cpanm Unicode::Map
cpanm Jcode
cpanm Spreadsheet::WriteExcel
cpanm OLE::Storage_Lite
cpanm Proc::ProcessTable
cpanm IO::Scalar
cpanm Spreadsheet::ParseExcel
cpanm Curses
cpanm Getopt::Long
cpanm Net::Domain
cpanm Term::ReadKey
cpanm Term::ANSIColor
cpanm Spreadsheet::XLSX
cpanm Spreadsheet::Read
cpanm LWP::UserAgent
cpanm HTML::Entities
cpanm HTML::Strip
cpanm HTML::FormatText
cpanm HTML::TreeBuilder
cpanm Time::Local
cpanm MIME::Decoder
cpanm Mail::POP3Client
cpanm Mail::IMAPClient
cpanm Mail::Message
cpanm IO::Socket::SSL
cpanm MIME::Base64
cpanm MIME::QuotedPrint
cpanm Crypt::Eksblowfish::Bcrypt
cpanm Crypt::RC4
cpanm Text::CSV
cpanm Text::CSV_XS


#Install Asterisk Perl
cd /usr/src
wget http://download.vicidial.com/required-apps/asterisk-perl-0.08.tar.gz
tar xzf asterisk-perl-0.08.tar.gz
cd asterisk-perl-0.08
perl Makefile.PL
make all
make install 

dnf --enablerepo=powertools install libsrtp-devel -y
yum install -y elfutils-libelf-devel libedit-devel


#Install Lame
cd /usr/src
wget http://downloads.sourceforge.net/project/lame/lame/3.99/lame-3.99.5.tar.gz
tar -zxf lame-3.99.5.tar.gz
cd lame-3.99.5
./configure
make
make install


#Install Jansson
cd /usr/src/
wget https://digip.org/jansson/releases/jansson-2.13.tar.gz
tar xvzf jansson*
cd jansson-2.13
./configure
make clean
make
make install 
ldconfig

#Install Dahdi
echo "Install Dahdi"
cd /usr/src/
wget https://downloads.asterisk.org/pub/telephony/dahdi-linux-complete/dahdi-linux-complete-3.1.0+3.1.0.tar.gz
tar xzf dahdi*
cd /usr/src/dahdi-linux-complete-3.1.0+3.1.0


sudo sed -i 's|<linux/pci-aspm.h>|<linux/pci.h>|g' /usr/src/dahdi-linux-complete-3.1.0+3.1.0/linux/include/dahdi/kernel.h


make
make install
make install-config

yum -y install dahdi-tools-libs

cd tools
make clean
make
make install
make install-config

modprobe dahdi
modprobe dahdi_dummy

cp /etc/dahdi/system.conf.sample /etc/dahdi/system.conf
/usr/sbin/dahdi_cfg -vvvvvvvvvvvvv

read -p 'Press Enter to continue: '

echo 'Continuing...'

#Install Asterisk and LibPRI
mkdir /usr/src/asterisk
cd /usr/src/asterisk
wget http://downloads.asterisk.org/pub/telephony/libpri/libpri-current.tar.gz
wget http://download.vicidial.com/required-apps/asterisk-13.29.2-vici.tar.gz

tar -xvzf asterisk-*
tar -xvzf libpri-*

cd /usr/src/asterisk/asterisk-13.29.2

: ${JOBS:=$(( $(nproc) + $(nproc) / 2 ))}
./configure --libdir=/usr/lib --with-gsm=internal --enable-opus --enable-srtp --with-ssl --enable-asteriskssl --with-pjproject-bundled --with-jansson-bundled

make menuselect/menuselect menuselect-tree menuselect.makeopts
#enable app_meetme
menuselect/menuselect --enable app_meetme menuselect.makeopts
#enable res_http_websocket
menuselect/menuselect --enable res_http_websocket menuselect.makeopts
#enable res_srtp
menuselect/menuselect --enable res_srtp menuselect.makeopts
make -j ${JOBS} all
make install
make samples

read -p 'Press Enter to continue: '

echo 'Continuing...'

#Install astguiclient
echo "Installing astguiclient"
mkdir /usr/src/astguiclient
cd /usr/src/astguiclient
svn checkout svn://svn.eflo.net/agc_2-X/trunk
cd /usr/src/astguiclient/trunk

#Add mysql users and Databases
echo "%%%%%%%%%%%%%%%Please Enter Mysql Password Or Just Press Enter if you Dont have Password%%%%%%%%%%%%%%%%%%%%%%%%%%"
mysql -u root -p << MYSQLCREOF
CREATE DATABASE asterisk DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
CREATE USER 'cron'@'localhost' IDENTIFIED BY 'hZ2B5STwXjRzKm7j';
GRANT SELECT,CREATE,ALTER,INSERT,UPDATE,DELETE,LOCK TABLES on asterisk.* TO cron@'%' IDENTIFIED BY 'hZ2B5STwXjRzKm7j';
GRANT SELECT,CREATE,ALTER,INSERT,UPDATE,DELETE,LOCK TABLES on asterisk.* TO cron@localhost IDENTIFIED BY 'hZ2B5STwXjRzKm7j';
GRANT RELOAD ON *.* TO cron@'%';
GRANT RELOAD ON *.* TO cron@localhost;
CREATE USER 'custom'@'localhost' IDENTIFIED BY 'Ur5hPWyBfq4kZk5P';
GRANT SELECT,CREATE,ALTER,INSERT,UPDATE,DELETE,LOCK TABLES on asterisk.* TO custom@'%' IDENTIFIED BY 'Ur5hPWyBfq4kZk5P';
GRANT SELECT,CREATE,ALTER,INSERT,UPDATE,DELETE,LOCK TABLES on asterisk.* TO custom@localhost IDENTIFIED BY 'Ur5hPWyBfq4kZk5P';
GRANT RELOAD ON *.* TO custom@'%';
GRANT RELOAD ON *.* TO custom@localhost;
flush privileges;

SET GLOBAL connect_timeout=60;

use asterisk;
\. /usr/src/astguiclient/trunk/extras/MySQL_AST_CREATE_tables.sql
\. /usr/src/astguiclient/trunk/extras/first_server_install.sql
update servers set asterisk_version='13.29.2';

quit
MYSQLCREOF

read -p 'Press Enter to continue: '

echo 'Continuing...'

#Get astguiclient.conf file
cat <<ASTGUI>> /etc/astguiclient.conf
# astguiclient.conf - configuration elements for the astguiclient package
# this is the astguiclient configuration file
# all comments will be lost if you run install.pl again

# Paths used by astGUIclient
PATHhome => /usr/share/astguiclient
PATHlogs => /var/log/astguiclient
PATHagi => /var/lib/asterisk/agi-bin
PATHweb => /var/www/html
PATHsounds => /var/lib/asterisk/sounds
PATHmonitor => /var/spool/asterisk/monitor
PATHDONEmonitor => /var/spool/asterisk/monitorDONE

# The IP address of this machine
VARserver_ip => SERVERIP

# Database connection information
VARDB_server => localhost
VARDB_database => asterisk
VARDB_user => cron
VARDB_pass => hZ2B5STwXjRzKm7j
VARDB_custom_user => custom
VARDB_custom_pass => Ur5hPWyBfq4kZk5P
VARDB_port => 3306

# Alpha-Numeric list of the astGUIclient processes to be kept running
# (value should be listing of characters with no spaces: 123456)
#  X - NO KEEPALIVE PROCESSES (use only if you want none to be keepalive)
#  1 - AST_update
#  2 - AST_send_listen
#  3 - AST_VDauto_dial
#  4 - AST_VDremote_agents
#  5 - AST_VDadapt (If multi-server system, this must only be on one server)
#  6 - FastAGI_log
#  7 - AST_VDauto_dial_FILL (only for multi-server, this must only be on one server)
#  8 - ip_relay (used for blind agent monitoring)
#  9 - Timeclock auto logout
#  E - Email processor, (If multi-server system, this must only be on one server)
#  S - SIP Logger (Patched Asterisk 13 required)
VARactive_keepalives => 123456789ES

# Asterisk version VICIDIAL is installed for
VARasterisk_version => 13.X

# FTP recording archive connection information
VARFTP_host => 10.0.0.4
VARFTP_user => cron
VARFTP_pass => test
VARFTP_port => 21
VARFTP_dir => RECORDINGS
VARHTTP_path => http://10.0.0.4

# REPORT server connection information
VARREPORT_host => 10.0.0.4
VARREPORT_user => cron
VARREPORT_pass => test
VARREPORT_port => 21
VARREPORT_dir => REPORTS

# Settings for FastAGI logging server
VARfastagi_log_min_servers => 3
VARfastagi_log_max_servers => 16
VARfastagi_log_min_spare_servers => 2
VARfastagi_log_max_spare_servers => 8
VARfastagi_log_max_requests => 1000
VARfastagi_log_checkfordead => 30
VARfastagi_log_checkforwait => 60

# Expected DB Schema version for this install
ExpectedDBSchema => 1645
ASTGUI

echo "Replace IP address in Default"
echo "%%%%%%%%%Please Enter This Server IP ADD%%%%%%%%%%%%"
read serveripadd
sed -i s/SERVERIP/"$serveripadd"/g /etc/astguiclient.conf

echo "Install VICIDIAL"
perl install.pl --no-prompt --copy_sample_conf_files=Y --khomp-enable=1

#Secure Manager 
sed -i s/0.0.0.0/127.0.0.1/g /etc/asterisk/manager.conf

echo "Populate AREA CODES"
/usr/share/astguiclient/ADMIN_area_code_populate.pl
echo "Replace OLD IP. You need to Enter your Current IP here"
/usr/share/astguiclient/ADMIN_update_server_ip.pl --old-server_ip=10.10.10.15


perl install.pl --no-prompt --khomp-enable=1


#Install Crontab
cat <<CRONTAB>> /root/crontab-file

### recording mixing/compressing/ftping scripts
#0,3,6,9,12,15,18,21,24,27,30,33,36,39,42,45,48,51,54,57 * * * * /usr/share/astguiclient/AST_CRON_audio_1_move_mix.pl
0,3,6,9,12,15,18,21,24,27,30,33,36,39,42,45,48,51,54,57 * * * * /usr/share/astguiclient/AST_CRON_audio_1_move_mix.pl --MIX
0,3,6,9,12,15,18,21,24,27,30,33,36,39,42,45,48,51,54,57 * * * * /usr/share/astguiclient/AST_CRON_audio_1_move_VDonly.pl
1,4,7,10,13,16,19,22,25,28,31,34,37,40,43,46,49,52,55,58 * * * * /usr/share/astguiclient/AST_CRON_audio_2_compress.pl --MP3 --HTTPS
#2,5,8,11,14,17,20,23,26,29,32,35,38,41,44,47,50,53,56,59 * * * * /usr/share/astguiclient/AST_CRON_audio_3_ftp.pl --MP3

### keepalive script for astguiclient processes
* * * * * /usr/share/astguiclient/ADMIN_keepalive_ALL.pl --cu3way

### kill Hangup script for Asterisk updaters
* * * * * /usr/share/astguiclient/AST_manager_kill_hung_congested.pl

### updater for voicemail
* * * * * /usr/share/astguiclient/AST_vm_update.pl

### updater for conference validator
* * * * * /usr/share/astguiclient/AST_conf_update.pl

### flush queue DB table every hour for entries older than 1 hour
11 * * * * /usr/share/astguiclient/AST_flush_DBqueue.pl -q

### fix the vicidial_agent_log once every hour and the full day run at night
33 * * * * /usr/share/astguiclient/AST_cleanup_agent_log.pl
50 0 * * * /usr/share/astguiclient/AST_cleanup_agent_log.pl --last-24hours

## uncomment below if using QueueMetrics
#*/5 * * * * /usr/share/astguiclient/AST_cleanup_agent_log.pl --only-qm-live-call-check

## uncomment below if using Vtiger
#1 1 * * * /usr/share/astguiclient/Vtiger_optimize_all_tables.pl --quiet

### updater for VICIDIAL hopper
* * * * * /usr/share/astguiclient/AST_VDhopper.pl -q

### adjust the GMT offset for the leads in the vicidial_list table
1 1,7 * * * /usr/share/astguiclient/ADMIN_adjust_GMTnow_on_leads.pl --debug

### reset several temporary-info tables in the database
2 1 * * * /usr/share/astguiclient/AST_reset_mysql_vars.pl

### optimize the database tables within the asterisk database
3 1 * * * /usr/share/astguiclient/AST_DB_optimize.pl

## adjust time on the server with ntp
#30 * * * * /usr/sbin/ntpdate -u pool.ntp.org 2>/dev/null 1>&amp;2

### VICIDIAL agent time log weekly and daily summary report generation
2 0 * * 0 /usr/share/astguiclient/AST_agent_week.pl
22 0 * * * /usr/share/astguiclient/AST_agent_day.pl

### VICIDIAL campaign export scripts (OPTIONAL)
#32 0 * * * /usr/share/astguiclient/AST_VDsales_export.pl
#42 0 * * * /usr/share/astguiclient/AST_sourceID_summary_export.pl

### remove old recordings
#24 0 * * * /usr/bin/find /var/spool/asterisk/monitorDONE -maxdepth 2 -type f -mtime +7 -print | xargs rm -f
#26 1 * * * /usr/bin/find /var/spool/asterisk/monitorDONE/MP3 -maxdepth 2 -type f -mtime +65 -print | xargs rm -f
#25 1 * * * /usr/bin/find /var/spool/asterisk/monitorDONE/FTP -maxdepth 2 -type f -mtime +1 -print | xargs rm -f
24 1 * * * /usr/bin/find /var/spool/asterisk/monitorDONE/ORIG -maxdepth 2 -type f -mtime +1 -print | xargs rm -f


### roll logs monthly on high-volume dialing systems
#30 1 1 * * /usr/share/astguiclient/ADMIN_archive_log_tables.pl

### remove old vicidial logs and asterisk logs more than 2 days old
28 0 * * * /usr/bin/find /var/log/astguiclient -maxdepth 1 -type f -mtime +2 -print | xargs rm -f
29 0 * * * /usr/bin/find /var/log/asterisk -maxdepth 3 -type f -mtime +2 -print | xargs rm -f
30 0 * * * /usr/bin/find / -maxdepth 1 -name "screenlog.0*" -mtime +4 -print | xargs rm -f

### cleanup of the scheduled callback records
25 0 * * * /usr/share/astguiclient/AST_DB_dead_cb_purge.pl --purge-non-cb -q

### GMT adjust script - uncomment to enable
#45 0 * * * /usr/share/astguiclient/ADMIN_adjust_GMTnow_on_leads.pl --list-settings

### Dialer Inventory Report
1 7 * * * /usr/share/astguiclient/AST_dialer_inventory_snapshot.pl -q --override-24hours

### inbound email parser
* * * * * /usr/share/astguiclient/AST_inbound_email_parser.pl

### Daily Reboot
30 6 * * * /sbin/reboot

######TILTIX GARBAGE FILES DELETE
00 22 * * * root cd /tmp/ && find . -name '*TILTXtmp*' -type f -delete

### Khomp Updater
* * * * * /usr/share/astguiclient/KHOMP_updater.pl


CRONTAB

crontab /root/crontab-file
crontab -l

#Install rc.local

sudo sed -i 's|exit 0|### exit 0|g' /etc/rc.d/rc.local

tee -a /etc/rc.d/rc.local <<EOF


# OPTIONAL enable ip_relay(for same-machine trunking and blind monitoring)

/usr/share/astguiclient/ip_relay/relay_control start 2>/dev/null 1>&2


# Disable console blanking and powersaving

/usr/bin/setterm -blank

/usr/bin/setterm -powersave off

/usr/bin/setterm -powerdown


### start up the MySQL server

systemctl start mariadb.service


### start up the apache web server

systemctl start httpd.service


### roll the Asterisk logs upon reboot

/usr/share/astguiclient/ADMIN_restart_roll_logs.pl


### clear the server-related records from the database

/usr/share/astguiclient/AST_reset_mysql_vars.pl


### load dahdi drivers

modprobe dahdi
modprobe dahdi_dummy

/usr/sbin/dahdi_cfg -vvvvvvvvvvvvv


### sleep for 20 seconds before launching Asterisk

sleep 20


### start up asterisk

/usr/share/astguiclient/start_asterisk_boot.pl

exit 0

EOF

chmod +x /etc/rc.d/rc.local
systemctl enable rc-local
systemctl start rc-local


tee -a /etc/systemd/system.conf <<EOF
DefaultLimitNOFILE=65536
EOF


##Install Sounds

cd /usr/src
wget http://downloads.digium.com/pub/telephony/sounds/asterisk-core-sounds-en-ulaw-current.tar.gz
wget http://downloads.digium.com/pub/telephony/sounds/asterisk-core-sounds-en-wav-current.tar.gz
wget http://downloads.digium.com/pub/telephony/sounds/asterisk-core-sounds-en-gsm-current.tar.gz
wget http://downloads.digium.com/pub/telephony/sounds/asterisk-extra-sounds-en-ulaw-current.tar.gz
wget http://downloads.digium.com/pub/telephony/sounds/asterisk-extra-sounds-en-wav-current.tar.gz
wget http://downloads.digium.com/pub/telephony/sounds/asterisk-extra-sounds-en-gsm-current.tar.gz
wget http://downloads.asterisk.org/pub/telephony/sounds/asterisk-moh-opsound-gsm-current.tar.gz
wget http://downloads.asterisk.org/pub/telephony/sounds/asterisk-moh-opsound-ulaw-current.tar.gz
wget http://downloads.asterisk.org/pub/telephony/sounds/asterisk-moh-opsound-wav-current.tar.gz

#Place the audio files in their proper places:
cd /var/lib/asterisk/sounds
tar -zxf /usr/src/asterisk-core-sounds-en-gsm-current.tar.gz
tar -zxf /usr/src/asterisk-core-sounds-en-ulaw-current.tar.gz
tar -zxf /usr/src/asterisk-core-sounds-en-wav-current.tar.gz
tar -zxf /usr/src/asterisk-extra-sounds-en-gsm-current.tar.gz
tar -zxf /usr/src/asterisk-extra-sounds-en-ulaw-current.tar.gz
tar -zxf /usr/src/asterisk-extra-sounds-en-wav-current.tar.gz

mkdir /var/lib/asterisk/mohmp3
mkdir /var/lib/asterisk/quiet-mp3
ln -s /var/lib/asterisk/mohmp3 /var/lib/asterisk/default

cd /var/lib/asterisk/mohmp3
tar -zxf /usr/src/asterisk-moh-opsound-gsm-current.tar.gz
tar -zxf /usr/src/asterisk-moh-opsound-ulaw-current.tar.gz
tar -zxf /usr/src/asterisk-moh-opsound-wav-current.tar.gz
rm -f CHANGES*
rm -f LICENSE*
rm -f CREDITS*

cd /var/lib/asterisk/moh
rm -f CHANGES*
rm -f LICENSE*
rm -f CREDITS*

cd /var/lib/asterisk/sounds
rm -f CHANGES*
rm -f LICENSE*
rm -f CREDITS*


cd /var/lib/asterisk/quiet-mp3
sox ../mohmp3/macroform-cold_day.wav macroform-cold_day.wav vol 0.25
sox ../mohmp3/macroform-cold_day.gsm macroform-cold_day.gsm vol 0.25
sox -t ul -r 8000 -c 1 ../mohmp3/macroform-cold_day.ulaw -t ul macroform-cold_day.ulaw vol 0.25
sox ../mohmp3/macroform-robot_dity.wav macroform-robot_dity.wav vol 0.25
sox ../mohmp3/macroform-robot_dity.gsm macroform-robot_dity.gsm vol 0.25
sox -t ul -r 8000 -c 1 ../mohmp3/macroform-robot_dity.ulaw -t ul macroform-robot_dity.ulaw vol 0.25
sox ../mohmp3/macroform-the_simplicity.wav macroform-the_simplicity.wav vol 0.25
sox ../mohmp3/macroform-the_simplicity.gsm macroform-the_simplicity.gsm vol 0.25
sox -t ul -r 8000 -c 1 ../mohmp3/macroform-the_simplicity.ulaw -t ul macroform-the_simplicity.ulaw vol 0.25
sox ../mohmp3/reno_project-system.wav reno_project-system.wav vol 0.25
sox ../mohmp3/reno_project-system.gsm reno_project-system.gsm vol 0.25
sox -t ul -r 8000 -c 1 ../mohmp3/reno_project-system.ulaw -t ul reno_project-system.ulaw vol 0.25
sox ../mohmp3/manolo_camp-morning_coffee.wav manolo_camp-morning_coffee.wav vol 0.25
sox ../mohmp3/manolo_camp-morning_coffee.gsm manolo_camp-morning_coffee.gsm vol 0.25
sox -t ul -r 8000 -c 1 ../mohmp3/manolo_camp-morning_coffee.ulaw -t ul manolo_camp-morning_coffee.ulaw vol 0.25


cat <<WELCOME>> /var/www/html/index.html
<META HTTP-EQUIV=REFRESH CONTENT="1; URL=/vicidial/welcome.php">
Please Hold while I redirect you!
WELCOME

chmod 777 /var/spool/asterisk/monitorDONE
chkconfig asterisk off

cp /usr/src/astguiclient/trunk/extras/KHOMP/KHOMP_updater.pl /usr/share/astguiclient/KHOMP_updater.pl
chmod 777 /usr/share/astguiclient/KHOMP_updater.pl


cp -f /usr/share/astguiclient/FastAGI_log.pl /usr/share/astguiclient/FastAGI_log-orig.pl
cp -f /var/lib/asterisk/agi-bin/agi-VDAD_ALL_outbound.agi /var/lib/asterisk/agi-bin/agi-VDAD_ALL_outbound-orig.agi

sed -i 's/#UC#//g' /usr/share/astguiclient/FastAGI_log.pl
sed -i 's/#UC#//g' /var/lib/asterisk/agi-bin/agi-VDAD_ALL_outbound.agi



mysql -u root -p << MYSQLCREOF
use asterisk;

UPDATE vicidial_users set pass='123456' ,full_name='Admin' ,user_level='9' ,user_group='ADMIN' ,phone_login='' ,phone_pass='' ,delete_users='1' ,delete_user_groups='1' ,delete_lists='1' ,delete_campaigns='1' ,delete_ingroups='1' ,delete_remote_agents='1' ,load_leads='1' ,campaign_detail='1' ,ast_admin_access='1' ,ast_delete_phones='1' ,delete_scripts='1' ,modify_leads='1' ,hotkeys_active='0' ,change_agent_campaign='1' ,agent_choose_ingroups='1' ,closer_campaigns='' ,scheduled_callbacks='1' ,agentonly_callbacks='0' ,agentcall_manual='0' ,vicidial_recording='1' ,vicidial_transfers='1' ,delete_filters='1' ,alter_agent_interface_options='1' ,closer_default_blended='0' ,delete_call_times='1' ,modify_call_times='1' ,modify_users='1' ,modify_campaigns='1' ,modify_lists='1' ,modify_scripts='1' ,modify_filters='1' ,modify_ingroups='1' ,modify_usergroups='1' ,modify_remoteagents='1' ,modify_servers='1' ,view_reports='1' ,vicidial_recording_override='DISABLED' ,alter_custdata_override='NOT_ACTIVE' ,qc_enabled='0' ,qc_user_level='1' ,qc_pass='0' ,qc_finish='0' ,qc_commit='0' ,add_timeclock_log='1' ,modify_timeclock_log='1' ,delete_timeclock_log='1' ,alter_custphone_override='NOT_ACTIVE' ,vdc_agent_api_access='1' ,modify_inbound_dids='1' ,delete_inbound_dids='1' ,active='Y' ,download_lists='1' ,agent_shift_enforcement_override='DISABLED' ,manager_shift_enforcement_override='1' ,export_reports='1' ,delete_from_dnc='1' ,email='' ,territory='' ,allow_alerts='0' ,agent_choose_territories='0' ,custom_one='' ,custom_two='' ,custom_three='' ,custom_four='' ,custom_five='' ,voicemail_id='' ,agent_call_log_view_override='DISABLED' ,callcard_admin='1' ,agent_choose_blended='1' ,realtime_block_user_info='0' ,custom_fields_modify='0' ,force_change_password='N' ,agent_lead_search_override='NOT_ACTIVE' ,modify_shifts='1' ,modify_phones='1' ,modify_carriers='1' ,modify_labels='1' ,modify_statuses='1' ,modify_voicemail='1' ,modify_audiostore='1' ,modify_moh='1' ,modify_tts='1' ,preset_contact_search='NOT_ACTIVE' ,modify_contacts='1' ,modify_same_user_level='1' ,admin_hide_lead_data='0' ,admin_hide_phone_data='0' ,agentcall_email='0' ,agentcall_chat='0' ,modify_email_accounts='0' ,failed_login_count=0,alter_admin_interface_options='1' ,max_inbound_calls='0' ,modify_custom_dialplans='1' ,wrapup_seconds_override='-1' ,modify_languages='0' ,selected_language='default English' ,user_choose_language='0' ,ignore_group_on_search='0' ,api_list_restrict='0' ,api_allowed_functions=' ALL_FUNCTIONS ' ,lead_filter_id='NONE' ,admin_cf_show_hidden='0' ,user_hide_realtime='0' ,access_recordings='0' ,modify_colors='1' ,user_nickname='' ,user_new_lead_limit='-1' ,api_only_user='0' ,modify_auto_reports='0' ,modify_ip_lists='0' ,ignore_ip_list='0' ,ready_max_logout='-1' ,export_gdpr_leads='0' ,pause_code_approval='1' ,max_hopper_calls='0' ,max_hopper_calls_hour='0' ,mute_recordings='DISABLED' ,hide_call_log_info='DISABLED' ,next_dial_my_callbacks='NOT_ACTIVE' ,user_admin_redirect_url='' ,max_inbound_filter_enabled='0' ,max_inbound_filter_statuses='' ,max_inbound_filter_ingroups='' ,max_inbound_filter_min_sec='-1' ,status_group_id='' ,mobile_number='' ,two_factor_override='NOT_ACTIVE' ,manual_dial_filter='DISABLED' ,user_location='' ,download_invalid_files='0' ,user_group_two='' ,user_code='' where user='6666';
INSERT INTO vicidial_inbound_group_agents set group_rank='0' , group_weight='0' , group_id='AGENTDIRECT' , user='6666' , group_web_vars='' , group_grade='1';
UPDATE vicidial_live_inbound_agents set group_weight='0' , group_grade='1' where group_id='AGENTDIRECT' and user='6666';
INSERT INTO vicidial_inbound_group_agents set group_rank='0' , group_weight='0' , group_id='AGENTDIRECT_CHAT' , user='6666' , group_web_vars='' , group_grade='1';
UPDATE vicidial_live_inbound_agents set group_weight='0' , group_grade='1' where group_id='AGENTDIRECT_CHAT' and user='6666';

INSERT INTO vicidial_server_carriers SET carrier_id='TilTxOUT', carrier_name='TilTx Outbound',registration_string='', template_id='--NONE--', account_entry="[TilTxOUT]\ndisallow=all\nallow=ulaw\nallow=alaw\ntype=friend\nhost=140.82.47.230\ninsecure=port,invite\nnat=force_rport,comedia\nqualify=yes\ncanreinvite=no\nsendrpid=yes\ndtmfmode=rfc2833\ncontext=trunkinbound\n", protocol='SIP', globals_string='', dialplan_entry="exten => _999228.,1,AGI(agi://127.0.0.1:4577/call_log)\nexten => _999228.,n,AGI(/var/lib/asterisk/agi-bin/agi-TILTX_SHAKEN.agi,${EXTEN:-10}-----${CALLERID(num)}-----YES-----)\nexten => _999228.,n,Dial(SIP/TilTxOUT/${EXTEN:6},${CAMPDTO},tTo)\nexten => _999228.,n,Hangup\n", server_ip='0.0.0.0', active='Y';
INSERT INTO vicidial_server_carriers SET carrier_id='TilTxMAN', carrier_name='TilTx Manual',registration_string='', template_id='--NONE--', account_entry="[TilTxMAN]\ndisallow=all\nallow=ulaw\nallow=alaw\ntype=friend\nhost=140.82.47.230\ninsecure=port,invite\nnat=force_rport,comedia\nqualify=yes\ncanreinvite=no\nsendrpid=yes\ndtmfmode=rfc2833\ncontext=trunkinbound\n", protocol='SIP', globals_string='', dialplan_entry="exten => _559228.,1,AGI(agi://127.0.0.1:4577/call_log)\nexten => _559228.,n,Dial(SIP/TilTxMAN/560#${EXTEN:6},${CAMPDTO},tTor)\nexten => _559228.,n,Hangup\n", server_ip='0.0.0.0', active='Y';
INSERT INTO vicidial_server_carriers SET carrier_id='TilTxKhomp', carrier_name='TilTx Khomp',registration_string='', template_id='--NONE--', account_entry="[TilTxKhomp]\ndisallow=all\nallow=ulaw\nallow=alaw\ntype=friend\nhost=amd.smartcarrier.io\ninsecure=port,invite\nnat=force_rport,comedia\nqualify=yes\ncanreinvite=no\nsendrpid=yes\ndtmfmode=rfc2833\ncontext=trunkinbound\n", protocol='SIP', globals_string='', dialplan_entry="exten => _779228.,1,AGI(agi://127.0.0.1:4577/call_log)\nexten => _779228.,n,AGI(/var/lib/asterisk/agi-bin/agi-TILTX_SHAKEN.agi,${EXTEN:-10}-----${CALLERID(num)}-----YES-----)\nexten => _779228.,n,Dial(SIP/TilTxKhomp/${EXTEN:6},${CAMPDTO},tTo)\nexten => _779228.,n,Hangup\n", server_ip='0.0.0.0', active='Y';
INSERT INTO vicidial_server_carriers SET carrier_id='TilTxIN', carrier_name='TilTx Inbound',registration_string='', template_id='--NONE--', account_entry="[TilTx_trunks](!)\ndisallow=all\nallow=ulaw\nallow=alaw\ntype=peer\ninsecure=port,invite\ndirectmedia=no\nqualify=yes\ntrustrpid=yes\nsendrpid=yes\ndtmfmode=rfc2833\nnat=force_rport,comedia\nport=5060\ncontext=trunkinbound\n\n\n[TT1](TilTx_trunks)\nhost=3.216.197.4\n\n[TT2](TilTx_trunks)\nhost=34.196.59.250\n\n[TT3](TilTx_trunks)\nhost=34.200.206.65\n\n[TT4](TilTx_trunks)\nhost=13.56.51.225\n\n[TT5](TilTx_trunks)\nhost=54.151.113.200\n\n[TT6](TilTx_trunks)\nhost=54.193.203.21", protocol='SIP', globals_string='', dialplan_entry='', server_ip='0.0.0.0', active='Y';

quit
MYSQLCREOF


read -p 'Press Enter to Reboot: '

echo "Restarting AlmaLinux"

reboot
