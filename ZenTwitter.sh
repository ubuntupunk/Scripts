#!/bin/bash
# @author Michael Klier <chi@chimeric.de>
# @www    http://www.chimeric.de/pojects/ZenTwitter

# trivial twitter status update client

# set username/password
USER="username"
PASS="password"

# main script
URL="https://twitter.com/statuses/update.xml"
ZENITY=/usr/bin/zenity
CURL=/usr/bin/curl

# check if zenity is installed
if [[ ! -x $ZENITY ]];
then
    echo "ERROR: zenity is missing!"
    exit 1
fi

# check if curl is installed
if [[ ! -x $CURL ]];
then
    $ZENITY --error --text="ERROR: curl is missing" --title="ZenTwitter"
    exit 1
fi

# get tweet
tweet=$(${ZENITY} --entry --text="Gimme your tweet:" --title="ZenTwitter")

if [[ "$?" == 1 ]];
then
    exit 0
fi

while [[ $(echo "${tweet}" | tr -d ' ') == "" ]];
do
    tweet=$(${ZENITY} --entry --text="D'oh! You entered nothing! Try again or cancel:" --title="ZenTwitter")
    if [[ "$?" == 1 ]];
    then
        exit 0
    fi
done

# update status
$CURL -u ${USER}:${PASS} -d status="${tweet}" ${URL} -k

if [[ "$?" == 0 ]];
then
    $ZENITY --info --text="Updated successful!" --title="ZenTwitter"
    exit 0
else
    $ZENITY --error --text="Something went wrong!\nRun ZenTwitter.sh from a commandline for more information!" --title="ZenTwitter"
    exit 1
fi
