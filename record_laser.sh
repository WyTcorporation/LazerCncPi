#!/bin/bash

TIMESTAMP=$(date +"%Y%m%d-%H%M%S")
FILENAME="laser_job_$TIMESTAMP.h264"

echo "🔴 Запис почався: $FILENAME"
libcamera-vid -o ~/Videos/$FILENAME --framerate 30 --width 1920 --height 1080
