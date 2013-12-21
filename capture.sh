#!/bin/sh

mkfifo stream.ogg
sudo modprobe vloopback
echo "CTRL-C to stop the capture"
sleep 5

# On a single line!
recordmydesktop -width 320 -height 240 -fps 15 --no-sound --on-the-fly-encoding --follow-mouse --overwrite -o stream.ogg & sleep 10 & ffmpeg -i stream.ogg -an -s 320x240 -r 15 -f yuv4mpegpipe - | mjpegtools_yuv_to_v4l /dev/video2
# End of single line

killall recordmydesktop
rm stream.ogg
