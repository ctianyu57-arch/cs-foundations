#!/bin/bash

dry_run=false

if [[ "${1:-}" == "--dry-run" ]]; then
    dry_run=true
    shift
fi

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 [--dry-run] TARGET_DIR"
    exit 1
fi

target=$1

if [[ ! -d "$target" ]]; then
    echo "Error: '$target' is not a directory"
    exit 1
fi
shopt -s nullglob

for file in "$target"/*; do
    if [[ ! -f "$file" ]]; then
        continue
    fi

    name=${file##*/}
    extension=${name##*.}

    if [[ "$name" == "$extension" ]]; then
        extension=""
    else
        extension=${extension,,}
    fi

    case "$extension" in
        pdf)
            category="pdf"
            ;;
        jpg|jpeg)
            category="jpg"
            ;;
        zip)
            category="zip"
            ;;
        *)
            category="other"
            ;;
    esac

        destination="$target/$category/$name"

    if [[ -e "$destination" ]]; then
        printf 'SKIP: %s already exists\n' "$destination"
        continue
    fi

    if [[ "$dry_run" == true ]]; then
        printf 'DRY-RUN: %s -> %s\n' "$name" "$destination"
    else
        mkdir -p "$target/$category"
        mv -- "$file" "$destination"
        printf 'MOVED: %s -> %s\n' "$name" "$destination"
    fi
done
