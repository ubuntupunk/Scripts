#!/bin/bash
echo "soundcloud.com music downloader by http://360percents.com";

if [ -z "$1" ]; then
	echo "";echo "Usage: `basename $0` [DJ-URL]";echo "";
	exit
fi

page=`wget $1 -q --user-agent='Mozilla/5.0' -O -`;
songs=`echo "$page" | grep 'streamUrl' | tr '"' "\n" | grep 'http://media.soundcloud.com/stream/'`;
songcount=`echo "$songs" | wc -l`
titles=`echo "$page" | grep 'title":"' | tr ',' "\n" | grep 'title' | cut -d '"' -f 4`

if [ -z "$songs" ]; then
	echo "No song found at this url.";
	exit;
fi

echo "Found $songcount songs!";

for (( songid=1; songid <= $songcount ; songid++ ))
do
	title=`echo "$titles" | sed -n "$songid"p`
	echo "Downloading $title..."
	wget -L `echo "$songs" | sed -n "$songid"p` -q --user-agent='Mozilla/5.0' -O "$title.mp3";
done
