# Daytime desktop - Automatic night mode and hour assigned wallpapers for Linux and Windows

This tool helps to sync our ciscardian clock and to feel time passing while in front of a screen by automatically adapting the desktop dark/light theme and wallpaper. 

## Instalation

Double click on linux/activate.sh (tested on mint cinamon and xfce desktops, readshift must be activated)
or windows/activate.vbs (tested on windows 10/11)

## hour wallpapers

Each wallpaper name must be prefixed by the two digit of the hour it appears and be placed in the ./hour-wallpapers folder.  
_e.g. "hour-wallpapers/13.my custom wapllpaper.jpg" will apear at 1pm._  

If several wallpaper are assigned to the same hour, the hour will be split equaly between each of those wallpapers.

## more tools

- _./browser-new-tab_ chrome extension: replace the default newtab with the desktop image without any distracting buttons.
- for chrome and firefox I recommand to install the _Dark Reader_ extension to automatically switch between light and dark theme at night.
- _Redshift_ for linux users https://github.com/jonls/redshift#redshift
- https://github.com/chrismah/ClickMonitorDDC7.2 for windows users can help to dim the screen automatically at night
- on windows search bar, look for _night light_ settings to have a warmer screen temperature at night.
- for visual studio code, look for the _Auto Day Night Theme Switcher_ extension
- for intellij idea, look for the _Day And Night_ extension
- original plugin for xfce only https://github.com/bimlas/xfce4-night-mode