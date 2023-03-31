#!/bin/sh
set -e

hexdump() {
    xxd -p | tr -d '\n' | sed 's/../& /g; s/ $/\n/'
}

body="$(dd if="$1" bs=1 skip=0 count=33 2> /dev/null | hexdump)"
meta="$(dd if="$1" bs=1 skip=33 count=14 2> /dev/null | hexdump)"

if printf '%s\n' "$body" | grep --color=always -w 21; then
    echo "Illegal bytes found in body!"
    exit 1
fi
