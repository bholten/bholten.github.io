#!/bin/sh

while inotifywait -r -e close_write content/; do
    ./build.el
done
