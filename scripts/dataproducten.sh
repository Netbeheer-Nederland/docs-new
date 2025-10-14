#!/bin/env bash


COMPONENT_NAME=$1
COMPONENT_DIR_SRC=src/dataproducten/$COMPONENT_NAME
COMPONENT_DIR_OUT=output/artifacts/dataproducten/$COMPONENT_NAME


function generate_antora_component_version {
    local version=$1
    local component_version_dir_src=$COMPONENT_DIR_SRC/$version
    local component_version_dir_out=$COMPONENT_DIR_OUT/$version

    echo Generating Antora component version…
    echo

    if [ ! -d $component_version_dir_src ] ; then
        echo Not a valid component version source directory: $component_version_dir_src && exit 1
    fi

    mkdir -p $component_version_dir_out
    cp -r $component_version_dir_src/documentation/* $component_version_dir_out

    mkdir -p $component_version_dir_out/modules/schema
    uv run python -m linkml_asciidoc_generator.main \
        $component_version_dir_src/models/$COMPONENT_NAME.linkml.yml \
        $component_version_dir_out/modules/schema \
        --relations-diagrams
    echo '- modules/schema/nav.adoc' >> $component_version_dir_out/antora.yml
    echo … OK.
    echo
}


function generate_antora_component {
    echo Generating Antora component…
    echo

    if [ ! -d $COMPONENT_DIR_SRC ] || [ -z $COMPONENT_NAME ] ; then
        echo Not a valid source directory: "$COMPONENT_DIR_SRC" && exit 1
    fi

    echo Cleaning $COMPONENT_DIR_OUT…
    rm -rf $COMPONENT_DIR_OUT
    mkdir -p $COMPONENT_DIR_OUT

    for version_dir in $COMPONENT_DIR_SRC/* ; do
        version=$(basename $version_dir)
        generate_antora_component_version $version
    done
    echo … OK.
    echo
}


### Main

generate_antora_component
