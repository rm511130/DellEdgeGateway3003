#!/bin/sh
# rmeira@pivotal.io 11-Feb-2018

# This script is designed to be executed by an Edge Gateway Device (e.g. model 3003) running Ubuntu Core 16
# It calculates the temperature inside the device and prints it out to stdout along with the date and time
# There are two sensors (hts221 and lps22hb) capable of registering the temperature inside the device
# So both temperature measurements are calculated and displayed ˚C and ˚F

# Depending on how the system allocates iio:device numbers, the path of the files may change
# So we first we find the exact location of the key files containing temperature data
# However, in the case of temperature, it may be possible to find in_temp_* under more than one device
# Device hts221 registers temperature in ˚C but it requires an offset adjustment
# Device lps22hb registers temperature in ˚C/1000 and it does not require an offset adjustment

device_0=`cat /sys/bus/iio/devices/iio:device0/name`
device_1=`cat /sys/bus/iio/devices/iio:device1/name`
device_2=`cat /sys/bus/iio/devices/iio:device2/name`

# echo "device0" $device_0
# echo "device1" $device_1
# echo "device2" $device_2

  if [ "$device_0" = "hts221" ]; then 
     in_temp_raw_path="/sys/bus/iio/devices/iio:device0/in_temp_raw"
     in_temp_scale_path="/sys/bus/iio/devices/iio:device0/in_temp_scale"
     in_temp_offset_path="/sys/bus/iio/devices/iio:device0/in_temp_offset"
     # echo "using device0 data"
  else if [ "$device_1" = "hts221" ]; then
          in_temp_raw_path="/sys/bus/iio/devices/iio:device1/in_temp_raw"
          in_temp_scale_path="/sys/bus/iio/devices/iio:device1/in_temp_scale"
          in_temp_offset_path="/sys/bus/iio/devices/iio:device1/in_temp_offset"
          # echo "using device1 data"
       else if [ "$device_2" = "hts221" ]; then
               in_temp_raw_path="/sys/bus/iio/devices/iio:device2/in_temp_raw"
               in_temp_scale_path="/sys/bus/iio/devices/iio:device2/in_temp_scale" 
               in_temp_offset_path="/sys/bus/iio/devices/iio:device2/in_temp_offset"
               # echo "using device2 data"
            else 
               echo "Problems: I could not find the hts221 device name"
            fi
       fi
  fi

# echo $in_temp_raw_path;
# echo $in_temp_scale_path;
# echo $in_temp_offset_path;

# We then get the content from each file

raw=`cat $in_temp_raw_path`
scale=`cat $in_temp_scale_path`
offset=`cat $in_temp_offset_path`
when=`date`

# We apply the formula to calculate the temperature in ˚C and ˚F 

awk -v r="$raw" -v s="$scale" -v w="$when" -v o="$offset" \
    'BEGIN { printf("%s --> HTS221  Device --> Temp = %f ˚C = %f ˚F\n",w,(r+o)*s,(r+o)*s*1.8+32.0); }'

# Now we do it all over again for the lps22hb device

  if [ "$device_0" = "lps22hb" ]; then
     in_temp_raw_path="/sys/bus/iio/devices/iio:device0/in_temp_raw"
     in_temp_scale_path="/sys/bus/iio/devices/iio:device0/in_temp_scale"
     # echo "using device0 data"
  else if [ "$device_1" = "lps22hb" ]; then
          in_temp_raw_path="/sys/bus/iio/devices/iio:device1/in_temp_raw"
          in_temp_scale_path="/sys/bus/iio/devices/iio:device1/in_temp_scale"
          # echo "using device1 data"
       else if [ "$device_2" = "lps22hb" ]; then
               in_temp_raw_path="/sys/bus/iio/devices/iio:device2/in_temp_raw"
               in_temp_scale_path="/sys/bus/iio/devices/iio:device2/in_temp_scale"
               # echo "using device2 data"
            else
               echo "Problems: I could not find the lps22hb device name"
            fi
       fi
  fi

# echo $in_temp_raw_path;
# echo $in_temp_scale_path;

# We then get the content from each file

raw=`cat $in_temp_raw_path`
scale=`cat $in_temp_scale_path`
when=`date`

# We apply the formula to calculate the temperature in ˚C and ˚F

awk -v r="$raw" -v s="$scale" -v w="$when" \
    'BEGIN { printf("%s --> LPS22HB Device --> Temp = %f ˚C = %f ˚F\n",w,r*s/1000.0,r*s*0.0018+32.0); }'

