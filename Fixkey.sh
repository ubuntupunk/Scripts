#!/bin/bash

ZENITY=/usr/bin/zenity

# check if zenity is installed
if [[ ! -x $ZENITY ]];
then
    echo "ERROR: zenity is missing!"
    exit 1
fi

# get missing key
key=$(${ZENITY} --entry --text="Gimme that key:" --title="FixKey")

if [[ "$?" == 1 ]];
then
    exit 0
fi

while [[ $(echo "${key}" | tr -d ' ') == "" ]];
do
    key=$(${ZENITY} --entry --text="D'oh! You entered nothing! Try again or cancel:" --title="FixKey")
    if [[ "$?" == 1 ]];
    then
        exit 0
    fi
done

# fixing key
$apt-key adv --recv-keys --keyserver keyserver.ubuntu.com ${key}

if [[ "$?" == 0 ]];
then
    $ZENITY --info --text="Updated successful!" --title="FixKey"
    exit 0
else
    $ZENITY --error --text="Something went wrong!\nRun FixKey.sh from a commandline for more information!" --title="FixKey"
    exit 1
fi
