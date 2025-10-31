#!/bin/env bash

# Copy source files to temporary output directory.


function copy_src_to_output_dir {
    echo Copying source to output directory…
    echo

    mkdir -p $OUT
    cp -r $SRC/* $OUT

    echo … OK.
    echo
}


### Main

copy_src_to_output_dir
