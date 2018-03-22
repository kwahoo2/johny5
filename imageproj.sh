#!/bin/bash
FILES="$@"
TEMPDIR=`mktemp -d`
for f in $FILES
do
        tmp=${f#*image}
        sname=stiched${tmp%}
		echo "Converting: $f $sname"
		convert $f -crop 1920x1920 "$TEMPDIR/cropped.jpg"
		convert -rotate 270 "$TEMPDIR/cropped-0.jpg" "$TEMPDIR/rotated-0.jpg"
        convert -rotate 90 "$TEMPDIR/cropped-1.jpg" "$TEMPDIR/rotated-1.jpg"
        nona -g -o "$TEMPDIR/out-0" -m TIFF -z LZW gearstereo.pto "$TEMPDIR/rotated-0.jpg"
        nona -g -o "$TEMPDIR/out-1" -m TIFF -z LZW gearstereo.pto "$TEMPDIR/rotated-1.jpg"
        convert "$TEMPDIR/out-0.tif" "$TEMPDIR/out-1.tif" +append $sname
done
rm -rf "$TEMPDIR"
