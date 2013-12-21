#!/bin/bash --
echo "MySpace music downloader by http://360percents.com"

if [ -z "$1" ]; then
	echo "";echo "Usage: `basename $0` [URL]";echo "";
	exit
fi

type -P rtmpdump &>/dev/null || {
	read -n1 -p "I need a program called rtmpdump, do you wan to install it now? (y/n) "
	echo
	[[ $REPLY = [yY] ]] && sudo apt-get install rtmpdump || { echo "You didn't answer yes, or installation failed. Install it manualy. Exiting...";}
	>&2; exit 1; }

echo "[+] Requesting $1"
page=`wget -L "$1" --quiet --user-agent="Mozilla" -O -`
userid=`echo "$page" | grep '?userId' | sed -e 's/.*userId=//' -e 's/".*//' | head -n 1`
artistid=`echo "$page" | grep '&artid' | sed -e 's/.*artid=//' -e 's/&.*//' | head -n 1`
if [ ! "$userid" ]; then
echo "[-] Trying second method for userID"
userid=`echo "$page" | grep 'UserId' | sed -e 's/.*UserId=//' | sed -e 's/&.*//g' | head -n 1`
fi
if [ ! "$userid" -o ! "$artistid" ]; then
echo '[+] ERROR: userid or artistid is empty!';
echo '[-] This is common when a change in MySpace occurs, or if this artists page is configured in a non usual way.';
echo '[-] See http://360percents.com/posts/linux-myspace-music-downloader/ for info.';
exit 1;
fi
echo "[-] User ID:$userid Artist ID:$artistid"
echo "[+] Requesting XML playlist"
link="http://musicservices.myspace.com/Modules/MusicServices/Services/MusicPlayerService.ashx?action=getArtistPlaylist&artistId=$artistid&artistUserId=$userid"
xml=`wget --quiet -L $link --user-agent="Mozilla" -O -`
songs=`echo "$xml" | tr ">" "\n" | grep 'songId' | tr ' ' "\n" | grep 'songId' | cut -d '"' -f 2`
songcount=`echo "$songs" | wc -l`
echo "[+] Found $songcount songs."

for i in `seq 1 $songcount`
do
songid=`echo "$songs" | sed -n "$i"p`
link="http://musicservices.myspace.com/Modules/MusicServices/Services/MusicPlayerService.ashx?action=getSong&ptype=4&sample=0&songId=$songid"
songpage=`wget -L "$link" --quiet --user-agent="Mozilla" -O -`
title=`echo "$songpage" | tr "<" "\n" | grep 'title' | tr ">" "\n" | grep -v 'title' | sed -e '/^$/d' | sort -u`
rtmp=`echo "$songpage" | tr "<" "\n" | tr ">" "\n" | grep 'rtmp://' | uniq`
if [ ! "$title" ]; then
#use number if no title found
title="$i"
fi
echo "Downloading $title..."
rtmpdump -r "$rtmp" -o "$title.flv" -q -W "http://lads.myspacecdn.com/videos/MSMusicPlayer.swf"
if which ffmpeg >/dev/null; then
	ffmpeg -i "$title.flv" -acodec copy "$title.mp3" &>/dev/null && rm "$title.flv"
fi
done
