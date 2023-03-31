#!/bin/sh
printf '%02x' "$#" | xxd -r -p | cat - "$@"
