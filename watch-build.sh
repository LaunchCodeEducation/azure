#! /usr/bin/env bash

# watch for changes and pipe out the file name
inotifywait -m --format "%f" -e create -e delete -e modify -r src | \

while read changed_file;
do
  echo "\n----- change detected in $changed_file - rebuilding docs -----\n"
  sphinx-build -b html-a11y src docs
done