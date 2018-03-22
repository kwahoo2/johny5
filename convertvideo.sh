#!/bin/bash
filename=$(basename $1)
tmp=${1#.*}
ffmpeg -i $1 -q:v 2 image%05d.jpg -acodec copy audio.aac
ls -1 image*.jpg | parallel --load 99% --noswap --memfree 500M --bar ./imageproj.sh {}
outname=${filename%.*}_180x180_3dh.mp4
ffmpeg -f image2 -framerate "30000/1001" -i stiched%5d.jpg -i audio.aac -c:v libx264 -c:a copy -vf "fps=30000/1001,format=yuv420p" $outname
rm -f *.jpg
rm -f audio.aac
