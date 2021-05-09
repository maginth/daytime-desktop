#!/bin/bash
# Cinnamon Night Mode: Switch between light and dark variants of a theme
#
# adapted from:
# https://github.com/bimlas/xfce4-night-mode

function show_usage()
{
  progname=`basename "$0"`
  echo "$progname [night|day|toggle]"
}

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
  if gsettings --version >> /dev/null; then
    gsettings $1 $2 $3 $4
  elif xconf-query --version >> /dev/null; then
    __set= [[ $1 == 'set' ]] && echo "--set $4"
    xfconf-query --channel $2 --property $3 $__set
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

  _conf_tool set $2 $3 "$new_theme"
}

function set_conf() {
  current_theme=`_conf_tool get $1 $2 | sed s/\'//g`
  if [[ $current_theme == $3 ]]; then
    return
  fi
  _conf_tool set $1 $2 $3
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

elif xconf-query --version >> /dev/null; then
  # GTK theme
  set_night_mode $mode xsettings /Net/ThemeName

  # Icon theme
  set_night_mode $mode xsettings /Net/IconThemeName

  # Window manager theme
  set_night_mode $mode xfwm4 /general/theme

fi


SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
folder=$SCRIPTPATH/hour-wallpapers
echo $SCRIPTPATH
echo $folder

if [[ -d $folder ]]
then

  list=( `ls -1 $folder | grep \`date +%H\`` )

  declare -i len=${#list[@]} m=`date +%_M` M=60

  selected="'file://$folder/${list[$(( $len*$m/$M ))]}'"

  current=`_conf_tool get org.cinnamon.desktop.background picture-uri`


  if [ $len != 0 ] && [ $selected != $current ]
  then
    echo change to wallpaper $selected
    _conf_tool set org.cinnamon.desktop.background picture-uri $selected
  fi
fi

#  echo 24000 | sudo tee /sys/class/backlight/intel_backlight/brightness

