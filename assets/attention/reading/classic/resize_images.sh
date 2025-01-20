#!/bin/bash
for file in *.png; do
    if [ -f "$file" ]; then
        # Zmień rozdzielczość obrazu na 400x400
        magick convert "$file" -resize 327x247 "$file"
    fi
done

