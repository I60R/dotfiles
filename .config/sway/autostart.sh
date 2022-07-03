dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
systemctl --user import-environment $SWAYSOCK
localectl set-x11-keymap us

GNOME_SCHEMA="org.gnome.desktop.interface"
gsettings set "${GNOME_SCHEMA}" gtk-theme "Qogir-ubuntu-light"
gsettings set "${GNOME_SCHEMA}" icon-theme "Breeze Maia"
gsettings set "${GNOME_SCHEMA}" font-name "Liberation Sans Regular 9"
gsettings set "${GNOME_SCHEMA}" cursor-theme "Fuchsia 22"


# Ensure to ecranize all special characters before running this
launch () {
    killall "$(basename $1)"
    exec "${@}" &
}

launch dunst
launch albert
launch ~/.cargo/bin/javelin firefox:-200  code:-250 chromium:-200 gthumb:200
launch ~/.config/sway/inactive-windows-transparency.py -o 0.72
launch flashfocus -t 160 -n 2 -o 0.86 --flash-lone-windows=always
launch systembus-notify
launch ydotoold

LOCKSCREEN="~/.config/sway/screenlock.sh"
LOCKSCREEN_INSTANT="~/.config/sway/screenlock-instant.sh"
launch swayidle \
    lock ${LOCKSCREEN} \
    before-sleep ${LOCKSCREEN_INSTANT} \
    timeout 300 ${LOCKSCREEN} \
    timeout 1800 $'"swaymsg output * dpms off"' resume $'"swaymsg output * dpms on"' \
    timeout 3600 $'"systemctl suspend"'

launch oguri
launch swayblur -a 3 -b 10
