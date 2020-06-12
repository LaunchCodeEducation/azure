#! /usr/bin/env bash

build_docs() {
  sphinx-build -b html-a11y /curriculum/src /docs
}

# initial clean build
rm -rf /docs/*
build_docs 

# watch for changes and pipe out the file name
inotifywait -m --format "%f" -e create -e delete -e modify -r /curriculum/src | \

while read changed_file;
do
  echo "\n----- change detected in $changed_file - rebuilding docs -----\n"
  build_docs
done