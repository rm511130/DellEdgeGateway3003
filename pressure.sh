#!/bin/sh

in_pressure_raw="$(ls -l /sys/bus/iio/devices/iio:device*/in_pressure_raw | awk '{ print $9; }')"
in_pressure_scale="$(ls -l /sys/bus/iio/devices/iio:device*/in_pressure_scale | awk '{ print $9; }')"

raw=`cat $in_pressure_raw`
scale=`cat $in_pressure_scale`
when=`date`

awk -v r="$raw" -v s="$scale" -v w="$when" \
'BEGIN { printf("%s --> Pressure = %f hPa = %f mm Hg = %f in Hg\n",w,r*s*10.0,r*s/0.133322387415,r*s*0.29299280306471);}'
