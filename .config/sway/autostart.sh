dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
systemctl --user import-environment $SWAYSOCK
localectl set-x11-keymap us


GNOME_INTERFACE='org.gnome.desktop.interface'
gsettings set "${GNOME_INTERFACE}" gtk-theme 'Qogir-Ubuntu-Light'
gsettings set "${GNOME_INTERFACE}" icon-theme 'Qogir-manjaro'
gsettings set "${GNOME_INTERFACE}" font-name 'Liberation Sans Regular 9'
gsettings set "${GNOME_INTERFACE}" cursor-theme 'Fuchsia'
gsettings set "${GNOME_INTERFACE}" cursor-size '22'
gsettings set "${GNOME_INTERFACE}" enable-animations 'false'
gsettings set "${GNOME_INTERFACE}" overlay-scrolling 'true'

GNOME_WM='org.gnome.desktop.wm.preferences'
gsettings set "${GNOME_WM}" button-layout 'appmenu:menu'
gsettings set "${GNOME_WM}" theme 'Qogir-Ubuntu-Light'
gsettings set "${GNOME_WM}" titlebar-font 'Droid Sans Bold 10'
gsettings set "${GNOME_WM}" action-double-click-titlebar 'toggle-maximize'
gsettings set "${GNOME_WM}" action-right-click-titlebar 'menu'


# Ensure to ecranize all special characters before running this
launch () {
    killall "$(basename $1)"
    exec "${@}" &
}

launch dunst
launch albert
launch javelin firefox:-200 code:-250 chromium:-200 gthumb:200
launch ~/.config/sway/inactive-windows-transparency.py -o 0.72
launch namedworkspaces
launch flashfocus -t 160 -n 2 -o 0.86 --flash-lone-windows=always
launch systembus-notify
launch ydotoold
launch clight
launch udiskie -anTF


LOCKSCREEN='~/.config/sway/screenlock.sh'
LOCKSCREEN_INSTANT='~/.config/sway/screenlock-instant.sh'
launch swayidle \
    lock ${LOCKSCREEN} \
    before-sleep ${LOCKSCREEN_INSTANT} \
    timeout 300 ${LOCKSCREEN} \
    timeout 1800 $'"swaymsg output * dpms off"' resume $'"swaymsg output * dpms on"' \
    timeout 3600 $'"systemctl suspend"'


launch oguri
launch swayblur -a 3 -b 10
