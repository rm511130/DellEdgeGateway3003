#!/bin/sh
# rmeira@pivotal.io 11-Feb-2018

# This script is designed to be executed by an Edge Gateway Device (e.g. model 3003) running Ubuntu Core 16
# It calculates the % Humidity inside of the device and prints it out to stdout along with the date and time

# Depending on how the system allocates iio:device numbers, the path of the files may change
# So we first we find the exact location of the three key files containing humidity data

in_humidityrelative_raw_path="$(ls -l /sys/bus/iio/devices/iio:device*/in_humidityrelative_raw | awk '{ print $9; }')"
in_humidityrelative_offset_path="$(ls -l /sys/bus/iio/devices/iio:device*/in_humidityrelative_offset | awk '{ print $9; }')"
in_humidityrelative_scale_path="$(ls -l /sys/bus/iio/devices/iio:device*/in_humidityrelative_scale | awk '{ print $9; }')"

# We then get the content from each file

raw=`cat $in_humidityrelative_raw_path`
offset=`cat $in_humidityrelative_offset_path`
scale=`cat $in_humidityrelative_scale_path`
when=`date`

# We apply the formula to calculate the % Humidity

awk -v r="$raw" -v o="$offset" -v s="$scale" -v w="$when" \
'BEGIN { printf("%s --> Humidity = %f %\n",w,(r+o)*s);}'
