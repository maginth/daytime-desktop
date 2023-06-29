#!/bin/bash
# Night Mode: Switch between light and dark variants of a theme
#
# adapted from:
# https://github.com/bimlas/xfce4-night-mode


function show_usage()
{
  progname=`basename "$0"`
  echo "$progname [night|day|toggle]"
}

if [[ $1 == wallpaper ]]; then
  show_usage
  exit 1
fi

function parse_args()
{
  case $# in
    0)
      echo "toggle"
      ;;
    1)
      echo "$1"
      ;;
    *)
      exit 1
  esac
}

function _conf_tool() {
  if gsettings --version >> /dev/null; then #cinnamon
    gsettings $1 $2 $3 $4
  elif xconf-query --version >> /dev/null; then #xfce
    __set= [[ $1 == 'set' ]] && echo "--set $4"
    xfconf-query --channel $2 --property $3 $__set
  else
    >&2 echo "no supported configuration tool detected"
    exit 1
  fi
}


function set_night_mode()
{
  current_theme=`_conf_tool get $2 $3 | sed s/\'//g`
  new_theme=`_set_$1 "$current_theme" 2> /dev/null`
  if [ $? != 0 ]; then
    show_usage
    exit 1
  fi
  if [[ -z $new_theme ]] || [[ $new_theme == $current_theme ]]; then
    return
  fi

  _conf_tool set $2 $3 "$new_theme"
}

function _set_toggle()
{
  if ( _is_dark "$1" ); then
    _set_day "$1"
  else
    _set_night "$1"
  fi
}

function _is_dark()
{
  echo "$1" | grep '\-Dark$' > /dev/null
}

SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
wallpaper_folder=$SCRIPTPATH/../hour-wallpapers

function _set_wallpaper() {
  h_now=`date +%H`
  h=$h_now
  while :
  do
    list=( `ls -1 $wallpaper_folder | grep $h` )
    len=${#list[@]}
    h=$((($h + 23) % 24))
    if [ $len -ne 0 ] || [ $h -ne h_now ]
    then
      break  
    fi
  done

  echo "file://$wallpaper_folder/${list[$(( $len*`date +%_M`/60 ))]}"
}

function _set_day()
{
  echo "${1%-Dark}"
}

function _set_night()
{
  if ( _is_dark "$1" ); then
    echo "$1"
  else
    echo "$1-Dark"
  fi
}

mode=`parse_args $@`
if [ $? != 0 ]; then
  show_usage
  exit 1
fi


if gsettings --version >> /dev/null; then
  # GTK theme
  set_night_mode $mode org.cinnamon.desktop.interface gtk-theme 

  # Icon theme
  set_night_mode $mode org.cinnamon.desktop.interface icon-theme

  # Window border theme
  set_night_mode $mode org.cinnamon.desktop.wm.preferences theme

  # Desktop theme
  set_night_mode $mode org.cinnamon.theme name

  if [[ -d $wallpaper_folder ]]; then
    set_night_mode wallpaper org.cinnamon.desktop.background picture-uri
  fi

elif xconf-query --version >> /dev/null; then
  # GTK theme
  set_night_mode $mode xsettings /Net/ThemeName

  # Icon theme
  set_night_mode $mode xsettings /Net/IconThemeName

  # Window manager theme
  set_night_mode $mode xfwm4 /general/theme

fi


#  echo 24000 | sudo tee /sys/class/backlight/intel_backlight/brightness

