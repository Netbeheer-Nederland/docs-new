#!/bin/env bash


SRC_DIR=src
ARTIFACTS_DIR=output/artifacts


### MAIN

echo Generating documentation…
echo
mkdir -p $ARTIFACTS_DIR

# Clean

echo "Cleaning up generated artifacts…"
echo
if [ -d $ARTIFACTS_DIR ]; then \
    rm -rf $ARTIFACTS_DIR; \
fi
mkdir -p $ARTIFACTS_DIR
echo "… OK."
echo

# Generate documentation artifacts

for type in dataproducten conceptuele-informatiemodellen ; do
    for component_dir in $SRC_DIR/$type/* ; do
        component=$(basename $component_dir)
        scripts/$type.sh $component
    done
done
