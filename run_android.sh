#!/bin/sh

EMULATOR_PATH="/Users/ludy/Library/Android/sdk/emulator/emulator"
AVD_NAME="Pixel_3a_API_TiramisuPrivacySandbox"

list()
{
  $EMULATOR_PATH -list-avds
}
run()
{
  $EMULATOR_PATH -avd $AVD_NAME > /dev/null 2>&1 &
}

case $1 in
  -l)
    list
    exit 0;
    ;;
esac

[ -z "$1" ] && run


