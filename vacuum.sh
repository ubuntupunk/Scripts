#!/bin/bash

username=$(whoami)
proc="$(ps aux | grep $username | grep -v $0 | grep firefox | grep -v grep)"
if [ "$proc" != "" ]
then
        echo "shutdown firefox first!"
        exit 1
fi

curdir=$(pwd)

for dir in $(cat ~/.mozilla/firefox/profiles.ini | grep Path= | sed -e 's/Path=//')
do
        cd ~/.mozilla/firefox/$dir 2>/dev/null
        if [ $? == 0 ]
        then
                echo "i'm in $(pwd)"
                echo -e "    running...\n"

                for F in $(find . -type f -name '*.sqlite' -print)
                do
                        sqlite3 $F "VACUUM;"
                done

                echo -e "done in  $(pwd) ...\n"
        else
                echo -e "\n    !!!! Nisam uspio uci u direktorij $dir, preskacem ga !!!!\n"
        fi
done
echo "Job finished";

cd $curdir