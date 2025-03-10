#!/bin/bash

function open_in_windows() {
    windows_path=$(wslpath -aw $1 | sed -e 's/ /\ /')
    "/mnt/c/Windows/explorer.exe" "$windows_path"
}

if [ $# -lt 1 ]; then
    open_in_windows "$(pwd)"
else
    for path in "$@"; do
        if [ -e "$path" ]; then
            open_in_windows "$path"
        else
            echo "file or directory $path does not exist."
        fi
    done
fi
