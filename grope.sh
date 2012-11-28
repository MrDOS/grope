#! /bin/sh

# Grab multipiece album art from Amazon.
# Usage:
#   ./grope.sh url output
# ...where URL is the URL of one piece of the album art, as shown by
# right-click -> Page Info after zooming in on the image, e.g.,
# http://z2-ec2.images-amazon.com/R/1/a=B0011Z1BII+c=A17SFUTIVB227Z+d=_SCR(3,2,0)_+o=01+s=RMTILE+va=MAIN+ve=391313817+e=.jpg
# (Yes, the whole thing.)

JPEGTRAN=jpegtran

PIECES=4
WIDTH=`expr $PIECES - 1`
HEIGHT=`expr $PIECES - 1`

if [ $# -lt 2 ]
then
	echo "Usage: $0 url output" 1>&2
	exit 1
fi

if ! type "$JPEGTRAN" 1>/dev/null 2>&1
then
    echo "jpegtran not found or not executable!" 1>&2
    exit 2
fi

if ! type "identify" 1>/dev/null 2>&1
then
    echo "ImageMagick not found!" 1>&2
    exit 2
fi

if ! echo "$1" | grep -q 'SCR([0-9],[0-9],[0-9])'
then
	echo "Inappropriate input."
	exit 3
fi

total_width=0
total_height=0

for x in `seq 0 $WIDTH`
do
	for y in `seq 0 $HEIGHT`
	do
		image=`echo "$1" | sed -e 's/SCR([0-9],[0-9],[0-9])/SCR(3,'${x}','${y}')/'`
		wget -q "$image" -O ${x}${y}.jpg

		if [ "$x" = "0" ]
		then
			height=`identify -format '%[fx:h]' ${x}${y}.jpg`
			total_height=`expr $total_height + $height`
		fi

		if [ "$y" = "0" ]
		then
			width=`identify -format '%[fx:w]' ${x}${y}.jpg`
			total_width=`expr $total_width + $width`
		fi
	done
done

convert -size ${total_width}x${total_height} xc:green "$2"

for x in `seq 0 $WIDTH`
do
	for y in `seq 0 $HEIGHT`
	do
		xpos=`expr $x \* 400`
		ypos=`expr $y \* 400`
		"$JPEGTRAN" -drop +${xpos}+${ypos} ${x}${y}.jpg -outfile "$2" "$2"
		rm ${x}${y}.jpg
	done
done

"$JPEGTRAN" -optimize -outfile "$2" "$2"