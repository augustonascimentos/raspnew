#!/bin/sh

xrandr --output HDMI-2 --auto;

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

while ! ping -c1 google.com &> /dev/null; do sleep 1; done

sed -i 's/"exited_cleanly":false/"exited_cleanly":true/' ~/.config/chromium/Default/Preferences
sed -i 's/"exited_cleanly":false/"exited_cleanly":true/; s/"exit_type":"[^"]\+"/"exit_type":"Normal"/' ~/.config/chromium/Default/Preferences

unclutter &
/usr/bin/chromium --start-fullscreen --kiosk --no-default-browser-check --no-first-run --disable-infobars --disable-session-crashed-bubble \
    --window-position=0,0 --window-size=$(xrandr | grep \* |awk '{print $1}' | tr 'x' ',') \
    'http://www.globo.com' &

while (true)
    do
       xdotool keydown ctrl+Tab; xdotool keyup ctrl+Tab;
       sleep 180
done