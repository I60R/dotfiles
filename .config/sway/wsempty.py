#!/usr/bin/env python3
# Spawn GUI program on an empty workspace

import sys, subprocess

from i3ipc import Connection


sway = Connection()


def execute_command(ws_number: int):
    sway.command('workspace number %d' % ws_number)
    subprocess.Popen(sys.argv[1:])


def main():
    i = 1
    for ws in sway.get_tree().workspaces():
        if not ws.leaves():
            execute_command(i)
            return
        if ws.num == i:
            i += 1
            continue
    execute_command(i)

if __name__ == "__main__":
    main()
