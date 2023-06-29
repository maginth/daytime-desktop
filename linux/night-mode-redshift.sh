#!/bin/bash
# Night Mode controlled by Redshift
#
# adapted from:
# https://github.com/bimlas/xfce4-night-mode

if ( LC_ALL='C' redshift -p 2> /dev/null | grep 'Period: Night' > /dev/null ); then
  mode='night'
else
  mode='day'
fi

"$(dirname "$0")/night-mode.sh" "$mode" | sed '/<tool>/,/<\/tool>/ d'
echo '<tool>
  Night mode defined by RedShift
  Click to toggle mode for a while
  </tool>'
