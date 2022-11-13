#!/usr/bin/python

# This script requires i3ipc-python package (install it from a system package manager
# or pip).
# It makes inactive windows transparent. Use `transparency_val` variable to control
# transparency strength in range of 0…1 or use the command line argument -o.

import argparse
import i3ipc
import signal
import sys
from functools import partial

def on_window_focus(inactive_opacity, ipc, event):
    tree = ipc.get_tree()

    global prev_focused
    global prev_workspace

    focused_workspace = tree.find_focused()

    if focused_workspace == None:
        return

    workspace = focused_workspace.workspace().num
    focused = event.container

    if focused.id != prev_focused.id:  # https://github.com/swaywm/sway/issues/2859
        focused.command("opacity 1")
        if workspace == prev_workspace:
            unfocused = tree.find_by_id(prev_focused.id)
            if unfocused is not None and "opaque" not in unfocused.marks:
                unfocused.command("opacity " + inactive_opacity)
        prev_focused = focused
        prev_workspace = workspace


def remove_opacity(ipc):
    for workspace in ipc.get_tree().workspaces():
        for w in workspace:
            w.command("opacity 1")
    ipc.main_quit()
    sys.exit(0)


def handle_mark(ipc, event):
    marked = event.container
    marked.command("border pixel 5" if "opaque" in marked.marks else "border pixel 1")

if __name__ == "__main__":
    transparency_val = "0.77"

    parser = argparse.ArgumentParser(
        description="This script allows you to set the transparency of unfocused windows in sway."
    )
    parser.add_argument(
        "--opacity",
        "-o",
        type=str,
        default=transparency_val,
        help="set opacity value in range 0...1",
    )
    args = parser.parse_args()

    ipc = i3ipc.Connection()

    prev_focused = None
    prev_workspace = ipc.get_tree().find_focused().workspace().num

    for window in ipc.get_tree():
        if window.focused:
            prev_focused = window
        else:
            window.command("opacity " + args.opacity)
    for sig in [signal.SIGINT, signal.SIGTERM]:
        signal.signal(sig, lambda signal, frame: remove_opacity(ipc))
    ipc.on("window::focus", partial(on_window_focus, args.opacity))
    ipc.on("window::mark", handle_mark)
    ipc.main()
