#!/usr/bin/env python3
# _*_ coding: utf-8 _*_

"""
This script uses the i3ipc python library to create dynamic workspace names in Sway / i3

Modified by: 160R@protonmail.com

Author: Piotr Miller
e-mail: nwg.piotr@gmail.com
Project: https://github.com/nwg-piotr/swayinfo
License: GPL3

Based on the example from https://github.com/altdesktop/i3ipc-python/blob/master/README.rst

Dependencies: python-i3ipc>=2.0.1 (i3ipc-python), python-xlib

Pay attention to the fact, that your workspaces need to be numbered, not named for the script to work.

Use:
bindsym $mod+1 workspace number 1

instead of:
bindsym $mod+1 workspace 1

in your ~/.config/sway/config or ~/.config/i3/config file.
"""

from i3ipc import Connection, Event

# Create the Connection object that can be used to send commands and subscribe to events.
i3 = Connection()


# Name the workspace after the focused window name
def assign_generic_name(i3, e):
    try:
        if e.change == 'rename':  # avoid looping
            return

        con = i3.get_tree().find_focused()
        if con.type == 'workspace':  # avoid renaming new empty workspaces on 'binding' event
            ws = con.workspace()
            ws_new_name = "%s<span color='lightgreen'>+</span>" % ws.num

            i3.command('rename workspace to "%s"' % ws_new_name)

        else:
            ws = con.workspace()
            leaves = ws.leaves()
            leaves_len = len(leaves)

            if e.change == 'new':
                # In sway we may open a new window w/o moving focus; let's give the workspace a name anyway.
                con = i3.get_tree().find_by_id(e.container.id)
                name = con.app_id or con.window_class or con.window_instance

                ws_name = "%s<span baseline_shift='superscript' color='cyan'>%s</span><span color='orange'>%s</span>" % (
                        ws.num, leaves_len, name
                )

                i3.command('rename workspace "%s" to %s' % (ws.num, ws_name))

            else:

                if con.type == 'floating_con':
                    split_text = '▪' if leaves_len == 0 else '▣'
                else:
                    if leaves_len == 1:
                        split_text = '■'
                    elif con.parent.layout == 'splith':
                        if leaves_len == 2:
                            split_text = '◧' if leaves[0] == con else '◨'
                        else:
                            split_text = ''
                            for x in range(0, leaves_len):
                                split_text += '▮' if leaves[x] == con else '▯'

                    elif con.parent.layout == 'splitv':
                        if leaves_len == 2:
                            split_text = '⬒' if leaves[0] == con else '⬓'
                        else:
                            split_text = '▤'
                    else:
                        split_text = '□'

                name = con.app_id or con.window_class or con.window_instance

                ws_old_name = ws.name
                ws_name = "%s<span baseline_shift='superscript' color='cyan'>%s</span> <span color='orange'>%s %s</span>" % (
                        ws.num, leaves_len, split_text, name
                )

                i3.command('rename workspace "%s" to %s' % (ws_old_name, ws_name))
    except:
        pass


def main():
    # Subscribe to events
    i3.on(Event.WORKSPACE_FOCUS, assign_generic_name)
    i3.on(Event.WINDOW_FOCUS, assign_generic_name)
    i3.on(Event.WINDOW_TITLE, assign_generic_name)
    i3.on(Event.WINDOW_CLOSE, assign_generic_name)
    i3.on(Event.WINDOW_NEW, assign_generic_name)
    i3.on(Event.BINDING, assign_generic_name)

    i3.main()


if __name__ == "__main__":
    main()
