#!/bin/bash
###### 	Date: 24/04/2020
######	Training: BIG-IP F5 LTM
######	Project: Automation 
######	Task: 	Automate backup of configuration files

echo "Version: 1.0 ¯\_(ツ)_/¯"
echo "╔═══════════════════════════════════════╗"
echo "║- Author: Saddam ZEMMALI               ║"
echo "║- eMail:  saddam.zemmali@gmail.com     ║"
echo "║- Version: 1.0                         ║"
echo "╚═══════════════════════════════════════╝"
mkdir -p "/opt/backup/BACKUPS_BIGIP"
TIMESTAMP=$(date +"%Y-%m-%d-%H-%M-%S")
LOGFILE="log-backup-bigip-$TIMESTAMP.log"
REMOTE_PATH="/var/tmp"
LOCAL_PATH="/opt/backup/BACKUPS_BIGIP"

REMOTE_BIGIP=bigip1
BACKUP_FILENAME=${REMOTE_BIGIP}_$TIMESTAMP.ucs

EMAIL="saddam.zemmali@gmail.com"

echo "╔═══════════════════════════════════════════════════════╗"
echo "║        Remotly Generate the .ucs file  [01]           ║"
echo "╚═══════════════════════════════════════════════════════╝"
echo "`date +%Y-%m-%d-%H:%M:%S` : Executes remotely the tmsh command to generate the .ucs file " > $LOCAL_PATH/$LOGFILE
ssh $REMOTE_BIGIP tmsh save /sys ucs $REMOTE_PATH/$BACKUP_FILENAME > /dev/null

echo "╔═══════════════════════════════════════════════════════╗"
echo "║        Copy the remote .ucs file [02]                 ║"
echo "╚═══════════════════════════════════════════════════════╝"
echo "`date +%Y-%m-%d-%H:%M:%S` : Copies the remote .ucs file to the configured local path " >> $LOCAL_PATH/$LOGFILE
scp $REMOTE_BIGIP:$REMOTE_PATH/$BACKUP_FILENAME $LOCAL_PATH/

echo "╔═══════════════════════════════════════════════════════╗"
echo "║          Removes the remote copy [03]                 ║"
echo "╚═══════════════════════════════════════════════════════╝"
echo "`date +%Y-%m-%d-%H:%M:%S` : Removes the remote copy of the file " >> $LOCAL_PATH/$LOGFILE
ssh $REMOTE_BIGIP rm $REMOTE_PATH/$BACKUP_FILENAME

echo "╔═══════════════════════════════════════════════════════╗"
echo "║          Email backup notification [04]               ║"
echo "╚═══════════════════════════════════════════════════════╝"
echo "`date +%Y-%m-%d-%H:%M:%S` : Send email backup notification with log file" >> $LOCAL_PATH/$LOGFILE
if [ -f $LOCAL_PATH/$BACKUP_FILENAME ]
then
        MSG_SUBJECT="Backup $REMOTE_BIGIP OK ($BACKUP_FILENAME)"
else
        MSG_SUBJECT="Backup $REMOTE_BIGIP FAIL!!"
fi

echo "`date +%Y-%m-%d-%H:%M:%S` : $MSG_SUBJECT" >> $LOCAL_PATH/$LOGFILE
mail -s "$MSG_SUBJECT" "$EMAIL" < "$LOGPATH$LOGFILE"
