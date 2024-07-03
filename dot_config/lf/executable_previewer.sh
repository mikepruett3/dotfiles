#!/usr/bin/env bash

MIME=$(mimetype --all --brief "$1")
#CATOPTS="--paging=never --style=changes --color=always"

case "$MIME" in
    # .pdf
    #*application/pdf*)
    #    pdftotext "$1" -
    #    ;;
    # .7z
    *application/x-7z-compressed*)
        7zz l "$1"
        ;;
    # .tar .tar.Z
    *application/x-tar*)
        tar -tvf "$1"
        ;;
    # .tar.*
    *application/x-compressed-tar*|*application/x-*-compressed-tar*)
        tar -tvf "$1"
        ;;
    # .rar
    *application/vnd.rar*)
        unrar l "$1"
        ;;
    # .zip
    *application/zip*)
        unzip -l "$1"
        ;;
    *application/vnd.debian.binary-package*)
        dpkg-deb --info "$1"
        ;;
    *application/x-cd-image*)
        7zz l "$1"
        ;;
    *text/markdown*)
        glow -s dark "$1"
        ;;
    *image/*)
        mediainfo "$1"
        ;;
    # any plain text file that doesn't have a specific handler
    *text/plain*)
        # return false to always repaint, in case terminal size changes
        #batcat $CATOPTS "$1"
        batcat "$1"
        ;;
    *application/octet-stream*)
        if [ "${1: -4,,}" == ".ans" ]; then
            ansiart2utf8 "$1"
        fi
        ;;
    *)
        echo "unknown format"
        ;;
esac
