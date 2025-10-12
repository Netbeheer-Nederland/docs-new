#!/bin/env bash

NAME=$1
VERSION=$2
COMPONENT_DIR_SRC=src/dataproducten/$NAME
COMPONENT_DIR_OUT=output/artifacts/dataproducten/$NAME
COMPONENT_VERSION_DIR_SRC=$COMPONENT_DIR_SRC/$VERSION
COMPONENT_VERSION_DIR_OUT=$COMPONENT_DIR_OUT/$VERSION

function generate_json_schema {
    echo Generating JSON Schema…
    echo

    mkdir -p $COMPONENT_VERSION_DIR_OUT/modules/schema/attachments/$NAME.json_schema.json
    uv run gen-json-schema \
        --not-closed \
        $COMPONENT_VERSION_DIR_SRC/models/$NAME.linkml.yml \
        > $COMPONENT_VERSION_DIR_OUT/schemas/json_schema/dp_capaciteitskaart.json_schema.json
    echo … OK.
    echo
    echo Generated JSON Schema at: artifacts/schemas/json_schema/dp_capaciteitskaart.json_schema.json
    echo
}


function generate_antora_component_version {
    echo Generating Antora component version…
    echo
    cp -r $COMPONENT_VERSION_DIR_SRC/documentation/* $COMPONENT_VERSION_DIR_OUT
    mkdir -p $COMPONENT_VERSION_DIR_OUT/modules/schema
    uv run python -m linkml_asciidoc_generator.main \
        $COMPONENT_VERSION_DIR_SRC/models/$NAME.linkml.yml \
        $COMPONENT_VERSION_DIR_OUT/modules/schema \
        --relations-diagrams
    echo '- modules/schema/nav.adoc' >> $COMPONENT_VERSION_DIR_OUT/antora.yml
    echo … OK.
    echo
}


function generate_documentation_artifacts {
    echo Generating documentation…
    echo
    echo Deleting $COMPONENT_VERSION_DIR_OUT…
    rm -rf $COMPONENT_VERSION_DIR_OUT
    mkdir -p $COMPONENT_VERSION_DIR_OUT
    generate_antora_component_version
    # generate_json_schema
}

generate_documentation_artifacts $1 $2
