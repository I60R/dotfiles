
SCREENSHOT_DIR="$HOME/Pictures/Screenshots/"
SCREENSHOT_PATH="$SCREENSHOT_DIR/Screenshot@$(date +'%Y-%m-%d@%H:%M:%S').png"

grim -g "$(slurp)" - \
    | swappy -f - -o - \
    | pngquant - > $SCREENSHOT_PATH \
    && notify-send "Screenshot saved as " $SCREENSHOT_PATH \
    && ~/.config/sway/wsempty.py gthumb $SCREENSHOT_DIR
