#!/bin/sh
# rmeira@pivotal.io 11-Feb-2018

# This script is designed to be executed by an Edge Gateway Device (e.g. model 3003) running Ubuntu Core 16
# It calculates the acceleration of the device and prints it out to stdout along with the date and time

# Depending on how the system allocates iio:device numbers, the path of the files may change
# So we first we find the exact location of the 6 key files containing accelerometer data

in_accel_x_raw_path="$(ls -l /sys/bus/iio/devices/iio:device*/in_accel_x_raw | awk '{ print $9; }')"
in_accel_y_raw_path="$(ls -l /sys/bus/iio/devices/iio:device*/in_accel_y_raw | awk '{ print $9; }')"
in_accel_z_raw_path="$(ls -l /sys/bus/iio/devices/iio:device*/in_accel_z_raw | awk '{ print $9; }')"
in_accel_x_scale_path="$(ls -l /sys/bus/iio/devices/iio:device*/in_accel_x_scale | awk '{ print $9; }')"
in_accel_y_scale_path="$(ls -l /sys/bus/iio/devices/iio:device*/in_accel_y_scale | awk '{ print $9; }')"
in_accel_z_scale_path="$(ls -l /sys/bus/iio/devices/iio:device*/in_accel_z_scale | awk '{ print $9; }')"

# We then get the content from each file

x_raw=`cat $in_accel_x_raw_path`
y_raw=`cat $in_accel_y_raw_path`
z_raw=`cat $in_accel_z_raw_path`
x_scale=`cat $in_accel_x_scale_path`
y_scale=`cat $in_accel_y_scale_path`
z_scale=`cat $in_accel_z_scale_path`
when=`date`

# We apply the formula to calculate the % Humidity

awk -v x="$x_raw" -v y="$y_raw" -v z="$z_raw" -v xs="$x_scale" -v ys="$y_scale" -v zs="$z_scale" -v w="$when" \
'BEGIN { printf("%s --> x_accel = %f y_accel = %f  z_accel = %f \n",w,x*xs,y*ys,z*zs);}'
