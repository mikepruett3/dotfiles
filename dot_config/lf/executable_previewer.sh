#!/usr/bin/env bash

OS="$(uname -s)"
case "${OS}" in
    Linux*)
        MIME=$(mimetype --all --brief "$1")
        ;;
    Darwin*)
        MIME=$(file --mime-type "$1")
        ;;
    *)
        echo "Unsupported operating system: ${OS}"
        exit 1
        ;;
esac

case "$MIME" in
    # .pdf
    *application/pdf*)
        pdftotext "$1" -
        ;;
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
    *application/octet-stream*)
        EXT="${1: -4}"
        EXT="${EXT,,}"
        case "$EXT" in
            .ans)
                ansiart2utf8 "$1"
                ;;
            .asc)
                ansiart2utf8 "$1"
                ;;
            *)
                echo "unknown binary format"
                ;;
        esac
        ;;
    # any plain text file that doesn't have a specific handler
    *text/plain*)
        case "${OS}" in
            Linux*)
                if [ -f /etc/manjaro-release ]; then
                    bat "$1"
                else
                    batcat "$1"
                fi
                ;;
            Darwin*)
                EXT="${1: -3}"
                case "$EXT" in
                    .md)
                        glow -s dark "$1"
                        ;;
                    *)
                        bat "$1"
                        ;;
                esac
                ;;
            *)
                echo "Unsupported operating system: ${OS}"
                exit 1
                ;;
        esac
        ;;
    *)
        echo "unknown format"
        ;;
esac
