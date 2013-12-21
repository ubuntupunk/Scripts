#!/bin/bash
username=$(whoami)

function check_app {
    proc="$(ps aux | grep $username | grep -v $0 | grep $1 | grep -v grep)"
    if [ "$proc" != "" ]
    then
        echo "!!! Shutdown $1 first!"
        exit 1
    fi
}

function vacuum_mozillas {
    echo "Vacuuming $1..."
    find $2 -type f -name '*.sqlite' -exec sqlite3 -line {} VACUUM \;
}

check_app firefox
check_app thunderbird
vacuum_mozillas firefox ~/.mozilla/firefox/
vacuum_mozillas thunderbird ~/.thunderbird

echo 'Done!'