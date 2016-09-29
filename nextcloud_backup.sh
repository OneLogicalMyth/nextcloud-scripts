/code
#!/bin/bash

echo "Starting nextcloud backup!"

# Variables change these to taste!
bdir=/mnt/storage/backups/nextcloud/`date +"%A"`/
sdir=/var/www/html
wusr=www-data
sqlu=username #Dont use root!
sqlp=PASSWORD
sqld=nextcloud

# below variables are file/folder management
removeifexists=true #removes the backup folder if present

# Don't change below this line
if [ -d "$bdir" ] && [ $removeifexists -eq true]; then
    echo "nextcloud backup directory $bdir already exists removing directory"
    rm -rf $bdir
fi

echo "Enabling nextcloud maintenance mode"
sudo -u www-data php $sdir/occ maintenance:mode --on

echo "Creating backup directory $bdir"
mkdir $bdir

echo "Running rsync from $sdir to $bdir"
rsync -Aax $sdir/ $bdir

echo "Dumping database to $bdir/database.bak"
mysqldump --lock-tables -h localhost -u $sqlu -p"$sqlp" $sqld > $bdir/database.bak

echo "Disabling nextcloud maintenance mode"
sudo -u www-data php $sdir/occ maintenance:mode --off

echo "nextcloud backup completed ok"