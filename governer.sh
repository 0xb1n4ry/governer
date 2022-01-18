#!/bin/bash

# while-menu-dialog: a menu driven system information program

DIALOG_CANCEL=1
DIALOG_ESC=255
HEIGHT=0
WIDTH=0

display_result() {
  dialog --title "$1" \
    --no-collapse \
    --msgbox "$result" 0 0
}

while true; do
  exec 3>&1
  selection=$(dialog \
    --backtitle "Select Governer" \
    --title "Menu" \
    --clear \
    --cancel-label "Exit" \
    --menu "Please select:" $HEIGHT $WIDTH 4 \
    "1" "Ondemand" \
    "2" "Powersave" \
    "3" "Performance" \
    "4" "Schedutil (AMD)" \
    "5" "Check current Governer" \
    2>&1 1>&3)
  exit_status=$?
  exec 3>&-
  case $exit_status in
    $DIALOG_CANCEL)
      clear
      echo "Program terminated."
      exit
      ;;
    $DIALOG_ESC)
      clear
      echo "Program aborted." >&2
      exit 1
      ;;
  esac
  case $selection in
    0 )
      clear
      echo "Program terminated."
      ;;
    1 )
      result=$(echo ondemand | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor)
      display_result "Ondemand"
      ;;
    2 )
      result=$(echo powersave | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor)
      display_result "Powersave"
      ;;
    3 )
      result=$(echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor)
      display_result "Performance"
      ;;
    4 )
      result=$(echo schedutil | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor)
      display_result "Schedutil"
      ;;
    5 )
      result=$(cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor)
      display_result "Check current Governer"
      ;;
  esac
done
