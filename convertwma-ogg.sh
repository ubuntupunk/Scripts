#!/bin/sh

# Convert a .wma to an .ogg using ‘mplayer’ and ‘oggenc’.

#

# Public Domain

set -e

IN=$1

shift

if [ -z "${IN}" ]; then

IN=-

WAV=audio.wav

else

WAV=$(basename ${IN} .wma).wav

fi

mplayer -vc dummy -vo null -ao pcm:waveheader:file=${WAV} ${IN}

FILEDAT=$(file ${WAV})

BITS=$(echo ${FILEDAT} | sed -e ‘s/.*\(8\|16\|32\) bit.*/\1/’)

if echo ${FILEDAT} | grep -q mono; then

CHANS=1

else

CHANS=2

fi

oggenc -R 44100 -B ${BITS} -C ${CHANS} ${WAV} >/dev/null

rm -f ${WAV}