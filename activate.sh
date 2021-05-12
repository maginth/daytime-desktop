#!/bin/bash

env > env-for-cron

script=night-mode-redshift.sh

SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

crontab -l | grep -v $script > tmp_cron

if [ "$1" != false ]
then
	COMMAND="set -a; . $SCRIPTPATH/env-for-cron ; bash $SCRIPTPATH/$script 2> $SCRIPTPATH/err-log-cron"
	echo "*/5 * * * * $COMMAND" >> tmp_cron
	echo "@reboot $COMMAND" >> tmp_cron

	echo "
Theme color and wallpaper will change automaticaly according to the time of the day.
Change the images in the folder $SCRIPTPATH/hour-wallpapers to choose which image is displayed at specific times of the day.
The two first caracters of the wallpaper name must be the hour at which it will display: 00 01 02 ... 21 22 23.
If more than one wallpaper is assigned to an hour they will display in their names order, 30min each for 2, 20 min each for 3, etc...

( to disable run: $0 false )
"
else
	echo theme and wallpaper automatic change is now disabled.
fi
crontab tmp_cron
rm tmp_cron


#TODO add startup launcher
