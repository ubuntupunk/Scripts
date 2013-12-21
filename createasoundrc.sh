% cat /usr/bin/asoundrc
#!/bin/bash
# asoundrc v0.1.0 20090101 markc@renta.net GPLv3
# asoundrc v0.2.0 20090320 quatro_por_quatro@yahoo.es GPLv3
#
# A simple script to create a particular default audio device regardless
# of what cards are loaded or in what order. It could be used anytime or
# placed in a ~/.bashrc script for a persistent setup every login.
#
# Usage: asoundrc [DEFAULT_CARD] > ~/.asoundrc

# use the first parameter as the card name, or else
# look for the sound card, discarding those that are only microphones
# when there are multiple cards, use the first one
if default_card="${1:-$(cat "$(for f in $(ls -1 /proc/asound/card[0-9]*/{midi,codec}* 2>/dev/null); do echo "${f%/*}"; done \
| sed -e '\|^[\[:blank:]\]$|d' -e 'q')/id" 2>/dev/null)}"; then
   echo "Using sound card: ${default_card}" >&2 
   cat /proc/asound/card[0-9]*/id | \
   gawk --assign default_card="${default_card}" \
'{print "pcm."$1" { type hw; card "$1"; }\nctl."$1" { type hw; card "$1"; }" }
END {print "pcm.!default pcm."default_card"\nctl.!default ctl."default_card}'
else
   echo "Warning: No sound cards found." >&2
fi
