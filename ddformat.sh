#!/bin/bash
DEVICE=$1
echo "Start format $DEVICE with zero"

sudo dd if=/dev/zero of=$DEVICE