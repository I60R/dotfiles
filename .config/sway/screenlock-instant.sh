swaymsg '
    input type:keyboard xkb_options "caps:none,shift:both_capslock,altwin:swap_alt_win,compose:ralt"
    input type:keyboard xkb_numlock disabled
    input type:keyboard xkb_layout us
'

swaylock -eFSkl \
    --indicator \
    --clock \
    --effect-pixelate=16 \
    --indicator-y-position=400 --indicator-radius=160 --indicator-thickness=32 \
    --layout-bg-color '#99999911' --layout-text-color '#99009999'
